//
//  MultipleChoiceStepView.swift
//  CleverDen
//

import SwiftUI

struct MultipleChoiceStepView: View {
    let step: MultipleChoiceStep
    let viewModel: LessonViewModel
    let onAnswerTap: (String) -> Void
    
    var body: some View {
        VStack(spacing: .spacingXL) {
            // Prompt
            promptSection
            
            // Options Grid
            optionsGrid
                .padding(.horizontal, .screenPadding)
        }
    }
    
    private var promptSection: some View {
        VStack(spacing: .spacingM) {
            if let promptImage = step.promptImage, !promptImage.isEmpty {
                Text(promptImage)
                    .font(.system(size: 80))
            }
            
            Text(step.prompt)
                .font(.question)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, .screenPadding)
        .padding(.vertical, .spacingXL)
    }
    
    private var optionsGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: .gridGap),
            GridItem(.flexible(), spacing: .gridGap)
        ]
        
        return LazyVGrid(columns: columns, spacing: .gridGap) {
            ForEach(step.options) { option in
                optionCard(for: option)
                    .onTapGesture {
                        onAnswerTap(option.id)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func optionCard(for option: MCOption) -> some View {
        let isSelected = viewModel.selectedOptionId == option.id
        let isCorrect = viewModel.isMCOptionCorrect(option.id)
        
        switch step.variant {
        case .countryToFlag:
            // Show large emoji flags as options
            AnswerCard(
                text: option.image ?? option.displayText,
                isSelected: isSelected,
                isCorrect: isCorrect,
                isEmoji: true
            )
        default:
            // Text options
            AnswerCard(
                text: option.displayText,
                isSelected: isSelected,
                isCorrect: isCorrect
            )
        }
    }
}
