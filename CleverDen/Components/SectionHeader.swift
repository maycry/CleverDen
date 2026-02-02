//
//  SectionHeader.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct SectionHeader: View {
    let section: Section
    
    var body: some View {
        VStack(spacing: .spacingXS) {
            Text("Section \(section.number)")
                .font(.label)
                .foregroundColor(.textSecondary)
            
            Text(section.title)
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity)
        .padding(.cardPadding)
        .background(Color.backgroundPrimary)
        .cornerRadius(.radiusFull)
    }
}
