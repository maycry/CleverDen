//
//  MatchPairsStepView.swift
//  CleverDen
//

import SwiftUI

struct MatchPairsStepView: View {
    let step: MatchPairsStep
    let viewModel: LessonViewModel
    let shuffledLeft: [String]
    let shuffledRight: [String]
    
    init(step: MatchPairsStep, viewModel: LessonViewModel) {
        self.step = step
        self.viewModel = viewModel
        // Shuffle once based on step id for consistency
        var leftGen = SeededRandomNumberGenerator(seed: step.id.hashValue)
        var rightGen = SeededRandomNumberGenerator(seed: step.id.hashValue &+ 1)
        self.shuffledLeft = step.pairs.map(\.left).shuffled(using: &leftGen)
        self.shuffledRight = step.pairs.map(\.right).shuffled(using: &rightGen)
    }
    
    var body: some View {
        VStack(spacing: .spacingXL) {
            Text("Match the pairs")
                .font(.question)
                .foregroundColor(.textPrimary)
                .padding(.top, .spacingXL)
            
            HStack(spacing: .spacingM) {
                // Left column
                VStack(spacing: .spacingS) {
                    ForEach(shuffledLeft, id: \.self) { item in
                        matchItem(text: item, column: .left)
                    }
                }
                
                // Right column
                VStack(spacing: .spacingS) {
                    ForEach(shuffledRight, id: \.self) { item in
                        matchItem(text: item, column: .right)
                    }
                }
            }
            .padding(.horizontal, .screenPadding)
        }
    }
    
    private func matchItem(text: String, column: MatchColumn) -> some View {
        let state = viewModel.matchItemState(text)
        let isLeftEmoji = step.pairs.first.map { isEmoji($0.left) } ?? false
        let showAsEmoji = (column == .left && isLeftEmoji)
        
        return Button {
            viewModel.selectMatchItem(column: column, id: text)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: .radiusCard)
                    .fill(matchItemColor(state))
                    .shadowSubtle()
                
                if showAsEmoji {
                    Text(text)
                        .font(.system(size: 36))
                        .padding(.spacingS)
                } else {
                    Text(text)
                        .font(.bodyLarge)
                        .foregroundColor(matchItemTextColor(state))
                        .padding(.spacingS)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(height: 56)
        }
        .disabled(state == .matched)
    }
    
    private func matchItemColor(_ state: MatchItemState) -> Color {
        switch state {
        case .idle: return .cardBackground
        case .selected: return .accentBlue.opacity(0.3)
        case .matched: return .accentGreen.opacity(0.3)
        case .wrong: return .accentOrange.opacity(0.3)
        }
    }
    
    private func matchItemTextColor(_ state: MatchItemState) -> Color {
        switch state {
        case .idle: return .textPrimary
        case .selected: return .accentBlue
        case .matched: return .accentGreen
        case .wrong: return .accentOrange
        }
    }
    
    private func isEmoji(_ string: String) -> Bool {
        guard let first = string.unicodeScalars.first else { return false }
        return first.properties.isEmoji && first.value > 0x238C
    }
}

// Seeded RNG for deterministic shuffling
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64
    
    init(seed: Int) {
        state = UInt64(bitPattern: Int64(seed))
        if state == 0 { state = 1 }
    }
    
    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}
