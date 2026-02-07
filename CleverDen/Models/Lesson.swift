//
//  Lesson.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

struct Lesson: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let sectionId: String
    let order: Int
    let iconName: String // SF Symbol name or asset name
    let questions: [Question]
    
    enum Status: Equatable {
        case locked
        case available
        case completed(diamonds: Int) // 1-3 diamonds earned
    }
}
