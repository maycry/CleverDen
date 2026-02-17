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
                    // Stars
                    StarDisplay(stars: viewModel.starsEarned, size: 32)
                        .padding(.top, .spacingXXXL)
                    
                    // Fox mascot
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.accentOrange)
                    
                    // Completion messages
                    VStack(spacing: .spacingS) {
                        Text(completionTitle)
                            .font(.headlineMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("Level completed")
                            .font(.body)
                            .foregroundColor(.textSecondary)
                    }
                    
                    // Continue button
                    PrimaryButton(title: "Continue", action: handleContinue)
                        .padding(.horizontal, .screenPadding)
                        .padding(.bottom, .spacingXL)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var completionTitle: String {
        switch viewModel.starsEarned {
        case 3: return "Perfect!"
        case 2: return "Great job!"
        default: return "Good effort!"
        }
    }
    
    private func handleContinue() {
        userProgress.markLessonComplete(
            lessonId: lesson.id,
            stars: viewModel.starsEarned
        )
        onContinue()
    }
}
