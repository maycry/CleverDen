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
    let onComplete: (Int) -> Void
    
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
            
            if lesson.steps.isEmpty {
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
                    LessonTopBar(progress: viewModel.progress) {
                        onDismiss()
                    }
                    
                    ZStack {
                        ScrollView {
                            VStack(spacing: .spacingXL) {
                                stepContent
                                    .padding(.bottom, showFeedbackSheet ? 200 : .spacingXL)
                            }
                        }
                        
                        VStack {
                            Spacer()
                            if showFeedbackSheet, let mode = viewModel.feedbackMode {
                                FeedbackSheet(mode: mode, onAction: handleFeedbackAction)
                                    .transition(.move(edge: .bottom))
                            }
                        }
                    }
                    .id(questionTransitionId)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: questionTransitionId)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showFeedbackSheet)
        .onChange(of: viewModel.feedbackMode) { _, newMode in
            showFeedbackSheet = newMode != nil
        }
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case .multipleChoice(let step):
            MultipleChoiceStepView(
                step: step,
                viewModel: viewModel,
                onAnswerTap: handleMCAnswerTap
            )
        case .matchPairs(let step):
            MatchPairsStepView(
                step: step,
                viewModel: viewModel
            )
        }
    }
    
    private func handleMCAnswerTap(optionId: String) {
        guard !viewModel.isStepComplete else { return }
        viewModel.selectOption(optionId)
        viewModel.submitOption()
    }
    
    private func handleFeedbackAction() {
        guard let mode = viewModel.feedbackMode else { return }
        
        switch mode {
        case .incorrectRetry:
            viewModel.retryMatchPairs()
            showFeedbackSheet = false
        case .correct, .incorrectFinal:
            if viewModel.isLastStep {
                onComplete(viewModel.totalErrors)
            } else {
                withAnimation(.easeInOut(duration: 0.35)) {
                    showFeedbackSheet = false
                    viewModel.moveToNextStep()
                    questionTransitionId += 1
                }
            }
        }
    }
}
