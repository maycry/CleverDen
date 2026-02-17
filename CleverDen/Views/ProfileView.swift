//
//  ProfileView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct ProfileView: View {
    let userProgress: UserProgress
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            VStack(spacing: .spacingXL) {
                // Profile header
                VStack(spacing: .spacingM) {
                    Image("foxLogo")
                    
                    Text("Profile")
                        .font(.headlineLarge)
                        .foregroundColor(.textPrimary)
                }
                .padding(.top, .spacingXXL)
                
                // Statistics
                VStack(spacing: .spacingL) {
                    StatCard(title: "Lessons Completed", value: "\(userProgress.completedLessons.count)")
                    StatCard(title: "Total Stars", value: "\(totalStars)")
                }
                .padding(.horizontal, .screenPadding)
                
                Spacer()
            }
        }
    }
    
    private var totalStars: Int {
        userProgress.completedLessons.values.reduce(0, +)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
        }
        .padding(.cardPadding)
        .background(Color.backgroundPrimary)
        .cornerRadius(.radiusCard)
        .shadowSubtle()
    }
}
