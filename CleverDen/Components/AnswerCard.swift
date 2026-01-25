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
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: .radiusCard)
                .fill(backgroundColor)
                .shadowSubtle()
            
            // Content
            Text(text)
                .font(.bodyLarge)
                .foregroundColor(isSelected ? .textOnAccent : .textPrimary)
                .padding(.cardPadding)
                .multilineTextAlignment(.center)
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return isCorrect == true ? .accentGreen : .accentOrange
        }
        return .cardBackground
    }
}
