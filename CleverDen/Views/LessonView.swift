//
//  LessonView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct LessonView: View {
    let lesson: Lesson
    @State private var viewModel: LessonViewModel
    @State private var showFeedbackSheet = false
    @Binding var userProgress: UserProgress
    let onDismiss: () -> Void
    let onComplete: (Int) -> Void // Pass error count
    
    init(lesson: Lesson, userProgress: Binding<UserProgress>, onDismiss: @escaping () -> Void, onComplete: @escaping (Int) -> Void) {
        self.lesson = lesson
        self._userProgress = userProgress
        self.onDismiss = onDismiss
        self.onComplete = onComplete
        self._viewModel = State(initialValue: LessonViewModel(lesson: lesson))
    }
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            if lesson.questions.isEmpty {
                // Error state - no questions
                VStack(spacing: .spacingXL) {
                    Text("No questions available")
                        .font(.headlineLarge)
                        .foregroundColor(.textPrimary)
                    Button("Close") {
                        onDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            } else {
                VStack(spacing: 0) {
                    // Top Bar
                    LessonTopBar(progress: viewModel.progress) {
                        onDismiss()
                    }
                    
                    ScrollView {
                        VStack(spacing: .spacingXL) {
                            // Question
                            QuestionView(question: viewModel.currentQuestion)
                            
                            // Answer Grid
                            answerGrid
                                .padding(.horizontal, .screenPadding)
                                .padding(.bottom, showFeedbackSheet ? 200 : .spacingXL)
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    // Feedback Sheet
                    if showFeedbackSheet {
                        FeedbackSheet(
                            isCorrect: viewModel.selectedAnswerId == viewModel.currentQuestion.correctAnswerId,
                            onContinue: handleContinue
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showFeedbackSheet)
    }
    
    private var answerGrid: some View {
        let answers = viewModel.currentQuestion.answers
        let columns = [
            GridItem(.flexible(), spacing: .gridGap),
            GridItem(.flexible(), spacing: .gridGap)
        ]
        
        return LazyVGrid(columns: columns, spacing: .gridGap) {
            ForEach(answers) { answer in
                AnswerCard(
                    text: answer.text,
                    isSelected: viewModel.selectedAnswerId == answer.id,
                    isCorrect: viewModel.isAnswerSubmitted ? viewModel.isAnswerCorrect(answer.id) : nil
                )
                .onTapGesture {
                    handleAnswerTap(answerId: answer.id)
                }
            }
        }
    }
    
    private func handleAnswerTap(answerId: String) {
        guard !viewModel.isAnswerSubmitted else { return }
        
        viewModel.selectAnswer(answerId)
        viewModel.submitAnswer()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showFeedbackSheet = true
        }
    }
    
    private func handleContinue() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showFeedbackSheet = false
        }
        
        if viewModel.isLastQuestion {
            // Navigate to completion screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onComplete(viewModel.errorCount)
            }
        } else {
            // Move to next question
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                viewModel.moveToNextQuestion()
            }
        }
    }
}
