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
    @State private var iconScale: CGFloat = 0.5
    @State private var contentOpacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: .spacingL) {
            // Feedback content
            HStack(spacing: .spacingM) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isCorrect ? .accentGreen : .accentOrange)
                    .scaleEffect(iconScale)
                
                Text(isCorrect ? "Correct" : "Incorrect")
                    .font(.bodyLarge)
                    .foregroundColor(isCorrect ? .accentGreen : .accentOrange)
                    .opacity(contentOpacity)
            }
            .padding(.top, .spacingXL)
            
            // Continue button
            PrimaryButton(title: "Continue", action: onContinue)
                .padding(.horizontal, .screenPadding)
                .padding(.bottom, .spacingXL)
                .opacity(contentOpacity)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.backgroundPrimary
                .cornerRadius(.radiusLarge, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
        )
        .shadowMedium()
        .onAppear {
            // Animate icon bounce
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                iconScale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    iconScale = 1.0
                }
            }
            
            // Fade in content
            withAnimation(.easeIn(duration: 0.3).delay(0.1)) {
                contentOpacity = 1.0
            }
        }
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
