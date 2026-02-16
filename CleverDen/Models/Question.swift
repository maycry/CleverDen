//
//  Question.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

struct Question: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let imageAsset: String?
    let answers: [Answer]
    let correctAnswerId: String
}

struct Answer: Identifiable, Codable, Hashable {
    let id: String
    let text: String
}
