//
//  ChallengeMatch.swift
//  CleverDen
//

import Foundation

struct ChallengeMatch {
    let player1Name: String
    let player2Name: String
    let totalRounds: Int
    var player1Score: Int = 0
    var player2Score: Int = 0
    var roundResults: [RoundResult] = []
    
    struct RoundResult {
        enum Winner {
            case player1, player2, none
        }
        let winner: Winner
    }
    
    var currentRound: Int {
        roundResults.count + 1
    }
    
    var isFinished: Bool {
        roundResults.count >= totalRounds
    }
    
    var winnerName: String? {
        guard isFinished else { return nil }
        if player1Score > player2Score { return player1Name }
        if player2Score > player1Score { return player2Name }
        return nil
    }
    
    var isTie: Bool {
        isFinished && player1Score == player2Score
    }
}
