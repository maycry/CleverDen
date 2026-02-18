//
//  ChallengeResultView.swift
//  CleverDen
//

import SwiftUI

struct ChallengeResultView: View {
    let match: ChallengeMatch
    let onRematch: () -> Void
    let onDone: () -> Void
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            VStack(spacing: .spacingXL) {
                Spacer()
                
                // Trophy
                Text("🏆")
                    .font(.system(size: 72))
                
                // Winner text
                if match.isTie {
                    Text("It's a Tie!")
                        .font(.headlineLarge)
                        .foregroundColor(.textPrimary)
                } else if let winner = match.winnerName {
                    Text("\(winner) Wins!")
                        .font(.headlineLarge)
                        .foregroundColor(.textPrimary)
                }
                
                // Score
                Text("\(match.player1Score) : \(match.player2Score)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .monospacedDigit()
                
                // Round dots summary
                HStack(spacing: .spacingM) {
                    VStack(spacing: .spacingS) {
                        Text(match.player1Name)
                            .font(.bodyLarge)
                            .foregroundColor(.textSecondary)
                        roundDotsRow(for: 1)
                    }
                    
                    VStack(spacing: .spacingS) {
                        Text(match.player2Name)
                            .font(.bodyLarge)
                            .foregroundColor(.textSecondary)
                        roundDotsRow(for: 2)
                    }
                }
                
                Spacer()
                
                // Buttons
                VStack(spacing: .spacingM) {
                    Button {
                        onRematch()
                    } label: {
                        Text("Rematch")
                            .font(.headlineMedium)
                            .foregroundColor(.textOnAccent)
                            .frame(maxWidth: .infinity)
                            .padding(.spacingM)
                            .background(Color.accentGreen)
                            .cornerRadius(.radiusCard)
                    }
                    
                    Button {
                        onDone()
                    } label: {
                        Text("Done")
                            .font(.headlineMedium)
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.spacingM)
                            .background(Color.cardBackground)
                            .cornerRadius(.radiusCard)
                            .shadowSubtle()
                    }
                }
                .padding(.horizontal, .screenPadding)
                .padding(.bottom, .spacingXXL)
            }
        }
        .onAppear {
            OrientationManager.shared.lockPortrait()
        }
    }
    
    private func roundDotsRow(for player: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<match.totalRounds, id: \.self) { index in
                Circle()
                    .fill(dotColor(roundIndex: index, player: player))
                    .frame(width: 12, height: 12)
            }
        }
    }
    
    private func dotColor(roundIndex: Int, player: Int) -> Color {
        guard roundIndex < match.roundResults.count else {
            return .progressTrack
        }
        let result = match.roundResults[roundIndex]
        let won = (player == 1 && result.winner == .player1) ||
                  (player == 2 && result.winner == .player2)
        return won ? .accentGreen : .progressTrack
    }
}
