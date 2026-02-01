//
//  FeedbackSheet.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI
import UIKit

struct FeedbackSheet: View {
    let isCorrect: Bool
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: .spacingL) {
            // Feedback content
            HStack(spacing: .spacingM) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isCorrect ? .accentGreen : .accentOrange)
                
                Text(isCorrect ? "Correct" : "Incorrect")
                    .font(.bodyLarge)
                    .foregroundColor(isCorrect ? .accentGreen : .accentOrange)
            }
            .padding(.top, .spacingXL)
            
            // Continue button
            PrimaryButton(title: "Continue", action: onContinue)
                .padding(.horizontal, .screenPadding)
                .padding(.bottom, .spacingXL)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.backgroundPrimary
                .cornerRadius(.radiusLarge, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
        )
        .shadowMedium()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
