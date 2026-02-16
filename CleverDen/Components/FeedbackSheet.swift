//
//  FeedbackSheet.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI
import UIKit

enum FeedbackMode: Equatable {
    case pendingCheck
    case correct
    case incorrectRetry
    case incorrectFinal
    
    var isCorrect: Bool { self == .correct }
    var isChecked: Bool { self != .pendingCheck }
    
    var title: String {
        switch self {
        case .pendingCheck: return ""
        case .correct: return "Correct"
        case .incorrectRetry, .incorrectFinal: return "Incorrect"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .pendingCheck: return "Check"
        case .correct, .incorrectFinal: return "Continue"
        case .incorrectRetry: return "Try Again"
        }
    }
    
    var iconName: String {
        isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
    }
    
    var color: Color {
        isCorrect ? .accentGreen : .accentOrange
    }
}

struct FeedbackSheet: View {
    let mode: FeedbackMode
    let onAction: () -> Void
    
    /// Convenience init for backward compatibility
    init(isCorrect: Bool, onContinue: @escaping () -> Void) {
        self.mode = isCorrect ? .correct : .incorrectFinal
        self.onAction = onContinue
    }
    
    init(mode: FeedbackMode, onAction: @escaping () -> Void) {
        self.mode = mode
        self.onAction = onAction
    }
    
    var body: some View {
        VStack(spacing: .spacingL) {
            // Result label — only visible after check
            if mode.isChecked {
                HStack(spacing: .spacingM) {
                    Image(systemName: mode.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(mode.color)
                    
                    Text(mode.title)
                        .font(.bodyLarge)
                        .foregroundColor(mode.color)
                }
                .padding(.top, .spacingXL)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Button — always at bottom
            PrimaryButton(title: mode.buttonTitle, action: onAction)
                .padding(.horizontal, .screenPadding)
                .padding(.top, mode.isChecked ? 0 : .spacingXL)
                .padding(.bottom, .spacingXL)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.backgroundPrimary
                .cornerRadius(.radiusLarge, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
        )
        .shadowMedium()
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: mode)
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
