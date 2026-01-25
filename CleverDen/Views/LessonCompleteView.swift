//
//  LessonCompleteView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct LessonCompleteView: View {
    let lesson: Lesson
    let errorCount: Int
    @State private var viewModel: LessonCompletionViewModel
    @Binding var userProgress: UserProgress
    let onContinue: () -> Void
    
    init(lesson: Lesson, errorCount: Int, userProgress: Binding<UserProgress>, onContinue: @escaping () -> Void) {
        self.lesson = lesson
        self.errorCount = errorCount
        self._userProgress = userProgress
        self.onContinue = onContinue
        self._viewModel = State(initialValue: LessonCompletionViewModel(lesson: lesson, errorCount: errorCount))
    }
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: .spacingXXL) {
                    // Diamonds
                    DiamondDisplay(diamonds: viewModel.diamondsEarned, size: 20)
                        .padding(.top, .spacingXXXL)
                    
                    // Fox mascot
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.accentOrange)
                    
                    // Completion messages
                    VStack(spacing: .spacingS) {
                        Text("Great job!")
                            .font(.headlineMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("Level completed")
                            .font(.body)
                            .foregroundColor(.textSecondary)
                    }
                    
                    // Reward meter
                    rewardMeter
                        .padding(.horizontal, .screenPadding)
                    
                    // Continue button
                    PrimaryButton(title: "Continue", action: handleContinue)
                        .padding(.horizontal, .screenPadding)
                        .padding(.bottom, .spacingXL)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var rewardMeter: some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            Text("Lever reward")
                .font(.body)
                .foregroundColor(.textSecondary)
            
            HStack(spacing: .spacingM) {
                // Progress bar
                ProgressBar(progress: rewardProgress)
                    .frame(height: 12)
                
                // Reward amount
                HStack(spacing: .spacingXS) {
                    Text("+\(viewModel.coinsEarned)")
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                    
                    Image(systemName: "circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.accentGold)
                }
            }
        }
        .padding(.cardPadding)
        .background(Color.backgroundPrimary)
        .cornerRadius(.radiusLarge)
        .shadowSubtle()
    }
    
    private var rewardProgress: Double {
        // Calculate progress based on coins earned (25, 50, or 75)
        // This is a simplified calculation - adjust based on your reward system
        if viewModel.coinsEarned == 75 {
            return 1.0
        } else if viewModel.coinsEarned == 50 {
            return 0.67
        } else {
            return 0.33
        }
    }
    
    private func handleContinue() {
        // Update user progress
        userProgress.markLessonComplete(
            lessonId: lesson.id,
            diamonds: viewModel.diamondsEarned,
            coinsEarned: viewModel.coinsEarned
        )
        
        // Navigate back (persistence will be handled by CourseView)
        onContinue()
    }
}
