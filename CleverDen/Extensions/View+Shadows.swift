//
//  View+Shadows.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

extension View {
    // Subtle elevation - cards, diamonds
    func shadowSubtle() -> some View {
        self.shadow(
            color: Color.black.opacity(0.08),
            radius: 4,
            x: 0,
            y: 2
        )
    }
    
    // Medium elevation - section headers, content cards
    func shadowMedium() -> some View {
        self.shadow(
            color: Color.black.opacity(0.15),
            radius: 8,
            x: 0,
            y: 4
        )
    }
    
    // Pronounced elevation - buttons, prominent elements
    func shadowPronounced() -> some View {
        self.shadow(
            color: Color.black.opacity(0.15),
            radius: 12,
            x: 0,
            y: 6
        )
    }
}
