//
//  MultipleChoiceStep.swift
//  CleverDen
//

import Foundation

enum MCVariant: String, Codable, Hashable {
    case flagToCountry
    case countryToFlag
    case textOnly
}

struct MCOption: Identifiable, Codable, Hashable {
    let id: String
    let text: String?
    let image: String?
    
    var displayText: String {
        text ?? image ?? ""
    }
}

struct MultipleChoiceStep: Identifiable, Codable, Hashable {
    let id: String
    let variant: MCVariant
    let prompt: String
    let promptImage: String?
    let options: [MCOption]
    let correctOptionId: String
}
