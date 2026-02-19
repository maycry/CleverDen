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
            case .finished:
                Color.clear
                    .onAppear { showResults = true }
            }
        }
        .onAppear {
            viewModel.startCountdown()
        }
        .fullScreenCover(isPresented: $showResults) {
            ChallengeResultView(
                match: viewModel.match,
                onRematch: {
                    showResults = false
                    viewModel.rematch(course: course)
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
            .id(number)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: number)
    }
    
    private var goView: some View {
        Text("GO!")
            .font(.system(size: 80, weight: .bold))
            .foregroundColor(.accentGreen)
            .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - Gameplay
    
    private var gameplayView: some View {
        VStack(spacing: 0) {
            // Top bar with X
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .frame(width: 44, height: 44)
                }
                Spacer()
            }
            .padding(.horizontal, .screenPadding)
            
            // Score bar
            scoreBar
                .padding(.horizontal, .screenPadding)
            
            Spacer().frame(height: .spacingXL)
            
            // Question
            questionView
                .padding(.horizontal, .screenPadding)
            
            Spacer().frame(height: .spacingXL)
            
            // Player labels
            HStack(spacing: .spacingM) {
                Text(viewModel.match.player1Name)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                
                Text(viewModel.match.player2Name)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, .screenPadding)
            .padding(.bottom, .spacingS)
            
            // Two columns of buttons
            HStack(alignment: .top, spacing: .spacingM) {
                playerColumn(player: 1)
                playerColumn(player: 2)
            }
            .padding(.horizontal, .screenPadding)
            
            Spacer()
        }
    }
    
    // MARK: - Score Bar
    
    private var scoreBar: some View {
        HStack {
            Text(viewModel.match.player1Name)
                .font(.bodyLarge)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
            
            roundDots(for: 1)
            
            Spacer()
            
            Text("\(viewModel.match.player1Score) : \(viewModel.match.player2Score)")
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
                .monospacedDigit()
            
            Spacer()
            
            roundDots(for: 2)
            
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
        .frame(maxWidth: .infinity)
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
            .frame(height: 60)
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
