//
//  Section.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

struct Section: Identifiable, Codable, Hashable {
    let id: String
    let courseId: String
    let number: Int
    let title: String
    let lessons: [Lesson]
}
