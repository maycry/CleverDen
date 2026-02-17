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
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: .spacingS) {
            // Main pill/icon
            ZStack {
                Capsule()
                    .fill(backgroundColor)
                    .frame(width: pillShapeWidth, height: pillShapeHeight)
                    .shadowSubtle()
                    .scaleEffect(pulseScale)
                
                Image(systemName: lesson.iconName)
                    .font(.system(size: iconSize))
                    .foregroundColor(iconColor)
            }
            
            // Stars (only for completed lessons)
            if case .completed(let stars) = status {
                StarDisplay(stars: stars)
            }
            
            // Label
            Text(lesson.title)
                .font(.labelSmall)
                .foregroundColor(labelColor)
                .multilineTextAlignment(.center)
        }
        .frame(width: pillWidth)
        .onAppear {
            if isNextLesson {
                // Pulse animation for next lesson
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulseScale = 1.05
                }
            }
        }
        .onChange(of: isNextLesson) { oldValue, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulseScale = 1.05
                }
            } else {
                withAnimation {
                    pulseScale = 1.0
                }
            }
        }
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
    
    private var pillShapeWidth: CGFloat {
        isNextLesson ? 100 * 1.1 : 100
    }
    
    private var pillShapeHeight: CGFloat {
        isNextLesson ? 128 * 1.1 : 128
    }
    
    private var iconSize: CGFloat {
        isNextLesson ? 40 * 1.1 : 40
    }
    
    private var pillWidth: CGFloat {
        140
    }
}
