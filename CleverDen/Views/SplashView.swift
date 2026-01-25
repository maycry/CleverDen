//
//  SplashView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            VStack(spacing: .spacingXL) {
                // Fox logo placeholder - using SF Symbol for now
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.accentOrange)
                    .opacity(opacity)
                
                Text("Clever Den")
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                opacity = 1.0
            }
            
            // Transition to course screen after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            CourseView()
        }
    }
}
