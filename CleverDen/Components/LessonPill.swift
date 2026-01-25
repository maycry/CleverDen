//
//  LessonPill.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct LessonPill: View {
    let lesson: Lesson
    let status: Lesson.Status
    let isNextLesson: Bool
    
    var body: some View {
        VStack(spacing: .spacingS) {
            // Main circle/icon
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: circleSize, height: circleSize)
                    .shadowSubtle()
                
                Image(systemName: lesson.iconName)
                    .font(.system(size: iconSize))
                    .foregroundColor(iconColor)
            }
            
            // Diamonds (only for completed lessons)
            if case .completed(let diamonds) = status {
                DiamondDisplay(diamonds: diamonds)
            }
            
            // Label
            Text(lesson.title)
                .font(.labelSmall)
                .foregroundColor(labelColor)
                .multilineTextAlignment(.center)
        }
        .frame(width: pillWidth)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .locked:
            return .inactiveGrey
        case .available, .completed:
            return .accentOrange
        }
    }
    
    private var iconColor: Color {
        switch status {
        case .locked:
            return .inactiveIcon
        case .available, .completed:
            return .textInverted
        }
    }
    
    private var labelColor: Color {
        switch status {
        case .locked:
            return .textInactive
        case .available, .completed:
            return .textSecondary
        }
    }
    
    private var circleSize: CGFloat {
        isNextLesson ? 120 : 100
    }
    
    private var iconSize: CGFloat {
        isNextLesson ? 48 : 40
    }
    
    private var pillWidth: CGFloat {
        isNextLesson ? 140 : 120
    }
}
