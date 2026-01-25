//
//  Section.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

struct Section: Identifiable, Codable {
    let id: String
    let number: Int
    let title: String
    let lessons: [Lesson]
}
