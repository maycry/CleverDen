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
    @State private var questionTransitionId: Int = 0
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
                    // Top Bar (stays put)
                    LessonTopBar(progress: viewModel.progress) {
                        onDismiss()
                    }
                    
                    // Animating content layer
                    ZStack {
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
                        
                        // Feedback Sheet as part of the animating content
                        VStack {
                            Spacer()
                            if showFeedbackSheet {
                                FeedbackSheet(
                                    isCorrect: viewModel.selectedAnswerId == viewModel.currentQuestion.correctAnswerId,
                                    onContinue: handleContinue
                                )
                                .transition(.move(edge: .bottom))
                            }
                        }
                    }
                    .id(questionTransitionId) // Forces re-render with transition
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: questionTransitionId)
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
        if viewModel.isLastQuestion {
            // Navigate to completion screen (handled by LessonFlowView)
            onComplete(viewModel.errorCount)
        } else {
            // Animate transition to next question
            withAnimation(.easeInOut(duration: 0.35)) {
                showFeedbackSheet = false
                viewModel.moveToNextQuestion()
                questionTransitionId += 1 // Trigger transition
            }
        }
    }
}
