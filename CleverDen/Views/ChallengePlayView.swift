//
//  ChallengePlayView.swift
//  CleverDen
//

import SwiftUI

struct ChallengePlayView: View {
    let course: Course
    @State private var viewModel: ChallengeViewModel
    @State private var showResults: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    init(course: Course, player1Name: String, player2Name: String) {
        self.course = course
        self._viewModel = State(initialValue: ChallengeViewModel(
            player1Name: player1Name,
            player2Name: player2Name,
            course: course
        ))
    }
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            switch viewModel.phase {
            case .countdown(let n):
                countdownView(number: n)
            case .go:
                goView
            case .playing, .roundResult:
                gameplayView
            case .gameOver:
                gameOverView
            case .finished:
                Color.clear
                    .onAppear {
                        OrientationManager.shared.lockPortrait {
                            showResults = true
                        }
                    }
            }
        }
        .onAppear {
            OrientationManager.shared.lockLandscape {
                viewModel.startCountdown()
            }
        }
        .onDisappear {
            OrientationManager.shared.lockPortrait()
        }
        .fullScreenCover(isPresented: $showResults) {
            ChallengeResultView(
                match: viewModel.match,
                onRematch: {
                    showResults = false
                    OrientationManager.shared.lockLandscape {
                        viewModel.rematch(course: course)
                    }
                },
                onDone: {
                    showResults = false
                    dismiss()
                }
            )
        }
    }
    
    // MARK: - Countdown
    
    private func countdownView(number: Int) -> some View {
        Text("\(number)")
            .font(.system(size: 96, weight: .bold))
            .foregroundColor(.textPrimary)
            .scaleEffect(1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: number)
            .id(number)
            .transition(.scale.combined(with: .opacity))
    }
    
    private var goView: some View {
        Text("GO!")
            .font(.system(size: 80, weight: .bold))
            .foregroundColor(.accentGreen)
            .transition(.scale.combined(with: .opacity))
    }
    
    private var gameOverView: some View {
        VStack(spacing: .spacingM) {
            Text("🏆")
                .font(.system(size: 64))
            if viewModel.match.isTie {
                Text("It's a Tie!")
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
            } else if let winner = viewModel.match.winnerName {
                Text("\(winner) Wins!")
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
            }
            Text("\(viewModel.match.player1Score) : \(viewModel.match.player2Score)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.textPrimary)
                .monospacedDigit()
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - Gameplay
    
    private var closeButton: some View {
        Button {
            OrientationManager.shared.lockPortrait()
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)
                .frame(width: 44, height: 44)
        }
    }
    
    private var gameplayView: some View {
        VStack(spacing: .spacingS) {
            // Score bar with close button
            HStack {
                closeButton
                scoreBar
                    .frame(maxWidth: .infinity)
                Spacer().frame(width: 44) // balance
            }
            .padding(.horizontal, .spacingS)
            .padding(.top, .spacingS)
            
            // Main content: P1 buttons | Question | P2 buttons
            HStack(spacing: 0) {
                // Player 1 buttons (left)
                playerColumn(player: 1)
                    .frame(maxWidth: .infinity)
                
                // Question in center
                questionView
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, .spacingM)
                
                // Player 2 buttons (right)
                playerColumn(player: 2)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, .spacingM)
            .padding(.bottom, .spacingS)
        }
    }
    
    // MARK: - Score Bar
    
    private var scoreBar: some View {
        HStack {
            // Player 1 name
            Text(viewModel.match.player1Name)
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
            
            // Player 1 dots
            roundDots(for: 1)
            
            Spacer()
            
            // Score
            Text("\(viewModel.match.player1Score) : \(viewModel.match.player2Score)")
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
                .monospacedDigit()
            
            Spacer()
            
            // Player 2 dots
            roundDots(for: 2)
            
            // Player 2 name
            Text(viewModel.match.player2Name)
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
        }
        .padding(.cardPadding)
        .background(Color.cardBackground)
        .cornerRadius(.radiusCard)
        .shadowSubtle()
    }
    
    private func roundDots(for player: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.match.totalRounds, id: \.self) { index in
                Circle()
                    .fill(dotColor(roundIndex: index, player: player))
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    private func dotColor(roundIndex: Int, player: Int) -> Color {
        guard roundIndex < viewModel.match.roundResults.count else {
            return .progressTrack
        }
        let result = viewModel.match.roundResults[roundIndex]
        let wonByThisPlayer = (player == 1 && result.winner == .player1) ||
                               (player == 2 && result.winner == .player2)
        return wonByThisPlayer ? .accentGreen : .progressTrack
    }
    
    // MARK: - Question
    
    private var questionView: some View {
        VStack(spacing: .spacingM) {
            if let question = viewModel.currentQuestion {
                // Prompt image (flag emoji for countryToFlag, etc.)
                if let promptImage = question.promptImage {
                    Text(promptImage)
                        .font(.system(size: 48))
                }
                
                Text(question.prompt)
                    .font(.question)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Player Column
    
    private func playerColumn(player: Int) -> some View {
        VStack(spacing: .spacingS) {
            ForEach(Array(viewModel.shuffledOptions.enumerated()), id: \.offset) { index, option in
                challengeOptionButton(player: player, option: option)
                    .id("slot-\(player)-\(index)")
            }
        }
    }
    
    private func challengeOptionButton(player: Int, option: MCOption) -> some View {
        let state = viewModel.optionState(player: player, optionId: option.id)
        let isEmoji = option.image != nil && option.text == nil
        let displayText = isEmoji ? (option.image ?? "") : (option.text ?? option.image ?? "")
        
        return Button {
            viewModel.playerTap(player: player, optionId: option.id)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: .radiusCard)
                    .fill(optionBackgroundColor(state))
                    .shadowSubtle()
                
                if isEmoji {
                    Text(displayText)
                        .font(.system(size: 32))
                        .padding(.spacingS)
                } else {
                    Text(displayText)
                        .font(.bodyLarge)
                        .foregroundColor(optionTextColor(state))
                        .padding(.spacingS)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
        .disabled(state == .disabled || state == .correct || state == .wrong || state == .correctReveal)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: state)
    }
    
    private func optionBackgroundColor(_ state: ChallengeViewModel.OptionState) -> Color {
        switch state {
        case .idle: return .cardBackground
        case .correct, .correctReveal: return .accentGreen
        case .wrong: return .accentOrange
        case .disabled: return .cardBackground.opacity(0.5)
        }
    }
    
    private func optionTextColor(_ state: ChallengeViewModel.OptionState) -> Color {
        switch state {
        case .idle: return .textPrimary
        case .correct, .wrong, .correctReveal: return .textOnAccent
        case .disabled: return .textInactive
        }
    }
}
