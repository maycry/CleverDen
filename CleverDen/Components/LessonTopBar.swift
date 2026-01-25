//
//  LessonTopBar.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct LessonTopBar: View {
    let progress: Double
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            // Close button
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            // Progress bar
            ProgressBar(progress: progress)
                .frame(maxWidth: 200)
            
            Spacer()
            
            // Spacer to balance the close button
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, .screenPadding)
        .padding(.vertical, .spacingM)
        .background(Color.backgroundSecondary)
    }
}
