//
//  FloatingNavBar.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct FloatingNavBar: View {
    @Binding var selectedTab: Tab
    
    enum Tab {
        case home
        case challenge
        case profile
    }
    
    var body: some View {
        HStack(spacing: .spacingXXL) {
            // Home icon
            Button(action: { selectedTab = .home }) {
                Image(systemName: "house.fill")
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == .home ? .textPrimary : .textSecondary)
            }
            
            // Challenge icon
            Button(action: { selectedTab = .challenge }) {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == .challenge ? .textPrimary : .textSecondary)
            }
            
            // Profile icon
            Button(action: { selectedTab = .profile }) {
                Image(systemName: "person.fill")
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == .profile ? .textPrimary : .textSecondary)
            }
        }
        .padding(.vertical, .spacingM)
        .padding(.horizontal, .spacingXL)
        .background(Color.backgroundPrimary)
        .cornerRadius(.radiusFull)
        .shadowMedium()
        .padding(.horizontal, .screenPadding)
        .padding(.bottom, .spacingL)
    }
}
