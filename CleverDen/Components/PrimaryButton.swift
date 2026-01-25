//
//  PrimaryButton.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodyLarge)
                .fontWeight(.bold)
                .foregroundColor(.textOnAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, .buttonPaddingV)
                .padding(.horizontal, .buttonPaddingH)
                .background(Color.accentOrange)
                .cornerRadius(.radiusLarge)
                .shadowPronounced()
        }
    }
}
