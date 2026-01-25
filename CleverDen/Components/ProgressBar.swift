//
//  ProgressBar.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct ProgressBar: View {
    let progress: Double // 0.0 to 1.0
    @State private var animatedProgress: Double = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.progressTrack)
                
                // Fill
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.accentOrange)
                    .frame(width: geometry.size.width * max(0, min(1, animatedProgress)))
            }
        }
        .frame(height: 8)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}
