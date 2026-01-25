//
//  Color+DesignSystem.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

extension Color {
    // MARK: - Background Colors
    static let backgroundPrimary = Color.white
    static let backgroundSecondary = Color(hex: "#EFEBE7")
    static let backgroundTertiary = Color(hex: "#E0DCD9")
    
    // MARK: - Primary Accent Colors
    static let accentOrange = Color(hex: "#FF5A35")
    static let accentOrangeSubdued = Color(hex: "#FC6441")
    static let accentGreen = Color(hex: "#2BD471")
    static let accentGold = Color(hex: "#FFB73B")
    static let accentGoldAlt = Color(hex: "#FF7D35")
    
    // MARK: - Text Colors
    static let textPrimary = Color(hex: "#1D1D1D")
    static let textSecondary = Color(hex: "#5E5E5E")
    static let textInverted = Color.white
    static let textInactive = Color(hex: "#9E9E9E")
    
    // MARK: - UI Element Colors
    static let cardBackground = Color.white
    static let textOnAccent = Color.white
    static let progressTrack = Color(hex: "#E5E5E5")
    static let inactiveGrey = Color(hex: "#D0D0D0")
    static let inactiveIcon = Color(hex: "#9E9E9E")
    static let inactiveStar = Color(hex: "#CCCCCC")
    
    // MARK: - Hex Color Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
