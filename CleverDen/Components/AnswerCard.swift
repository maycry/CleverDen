//
//  AnswerCard.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct AnswerCard: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    @State private var showParticles = false
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: .radiusCard)
                .fill(backgroundColor)
                .shadowSubtle()
                .overlay {
                    // Decorative particles for selected state
                    if isSelected {
                        particleOverlay
                    }
                }
            
            // Content
            Text(text)
                .font(.bodyLarge)
                .foregroundColor(isSelected ? .textOnAccent : .textPrimary)
                .padding(.cardPadding)
                .multilineTextAlignment(.center)
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .onChange(of: isSelected) { oldValue, newValue in
            if newValue {
                showParticles = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showParticles = false
                }
            }
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return isCorrect == true ? .accentGreen : .accentOrange
        }
        return .cardBackground
    }
    
    private var particleOverlay: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(
                        x: cos(Double(index) * .pi / 4) * 30,
                        y: sin(Double(index) * .pi / 4) * 30
                    )
                    .opacity(showParticles ? 1 : 0)
                    .scaleEffect(showParticles ? 1.5 : 0.5)
            }
        }
        .animation(.easeOut(duration: 0.5).delay(0.1), value: showParticles)
    }
}
