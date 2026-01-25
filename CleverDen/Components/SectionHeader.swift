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
        HStack {
            VStack(alignment: .leading, spacing: .spacingXS) {
                Text("Section \(section.number)")
                    .font(.label)
                    .foregroundColor(.textSecondary)
                
                Text(section.title)
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(.cardPadding)
        .background(Color.backgroundPrimary)
        .cornerRadius(.radiusLarge)
        .shadowMedium()
    }
}
