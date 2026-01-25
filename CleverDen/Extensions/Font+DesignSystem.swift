//
//  Font+DesignSystem.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

extension Font {
    // MARK: - Headlines
    static let headlineLarge = Font.system(size: 28, weight: .bold)
    static let headlineMedium = Font.system(size: 24, weight: .bold)
    
    // MARK: - Body Text
    static let bodyLarge = Font.system(size: 19, weight: .medium)
    static let body = Font.system(size: 17, weight: .regular)
    
    // MARK: - Question Text
    static let question = Font.system(size: 28, weight: .bold)
    
    // MARK: - Labels
    static let label = Font.system(size: 14, weight: .regular)
    static let labelSmall = Font.system(size: 13, weight: .regular)
}
