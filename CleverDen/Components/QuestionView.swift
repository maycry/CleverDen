//
//  QuestionView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    
    var body: some View {
        VStack(spacing: .spacingM) {
            if let imageAsset = question.imageAsset, !imageAsset.isEmpty {
                Text(imageAsset)
                    .font(.system(size: 80))
            }
            
            Text(question.text)
                .font(.question)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, .screenPadding)
        .padding(.vertical, .spacingXL)
    }
}
