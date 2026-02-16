//
//  MatchPairsStep.swift
//  CleverDen
//

import Foundation

struct MatchPair: Identifiable, Codable, Hashable {
    let id: String
    let left: String   // flag emoji
    let right: String  // country name
}

struct MatchPairsStep: Identifiable, Codable, Hashable {
    let id: String
    let pairs: [MatchPair]
}
