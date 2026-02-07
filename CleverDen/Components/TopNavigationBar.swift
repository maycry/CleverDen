//
//  TopNavigationBar.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct TopNavigationBar: View {
    let coins: Int
    
    var body: some View {
        HStack {
            // Fox logo
            Image("foxLogo")
            
            Spacer()
            
            // Coin counter
            HStack(spacing: .spacingXS) {
                Text("\(coins)")
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)
                
                Image(systemName: "circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.accentGold)
            }
            .padding(.horizontal, .spacingXS)
            .padding(.vertical, .spacingXS / 2)
            .background(.white)
            .clipShape(Capsule())
            .shadowSubtle()

        }
        .padding(.horizontal, .screenPadding)
        .frame(height: 64)
        .background(Color.backgroundSecondary)
    }
}
