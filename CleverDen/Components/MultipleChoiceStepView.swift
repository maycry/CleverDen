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
            // Prompt — always visible
            promptSection
            
            if viewModel.showGlobe, let countryName = step.countryName {
                // Globe replaces options after check
                ZStack {
                    Globe3DView(countryName: countryName)
                        .frame(height: 300)
                    
                    // Tooltip
                    VStack {
                        Text(countryName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.textOnAccent)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.accentOrange)
                            )
                        Spacer()
                    }
                    .padding(.top, 12)
                }
                .frame(height: 300)
                .padding(.horizontal, .screenPadding)
                .transition(.opacity)
            } else {
                // Options Grid
                optionsGrid
                    .padding(.horizontal, .screenPadding)
            }
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
            AnswerCard(
                text: option.image ?? option.displayText,
                isSelected: isSelected,
                isCorrect: isCorrect,
                isEmoji: true
            )
        default:
            AnswerCard(
                text: option.displayText,
                isSelected: isSelected,
                isCorrect: isCorrect
            )
        }
    }
}
