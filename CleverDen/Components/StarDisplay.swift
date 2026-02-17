//
//  StarDisplay.swift
//  CleverDen
//

import SwiftUI

struct StarDisplay: View {
    let stars: Int // 0-3
    let size: CGFloat
    
    init(stars: Int, size: CGFloat = 12) {
        self.stars = max(0, min(3, stars))
        self.size = size
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: size))
                    .foregroundColor(index < stars ? .accentGold : .inactiveStar)
            }
        }
    }
}
