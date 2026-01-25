//
//  DiamondDisplay.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct DiamondDisplay: View {
    let diamonds: Int // 0-3
    let size: CGFloat
    
    init(diamonds: Int, size: CGFloat = 12) {
        self.diamonds = max(0, min(3, diamonds))
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Image(systemName: "diamond.fill")
                    .font(.system(size: size))
                    .foregroundColor(index < diamonds ? .accentGold : .inactiveStar)
            }
        }
    }
}
