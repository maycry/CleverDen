//
//  ChallengeViewModel.swift
//  CleverDen
//

import Foundation
import Observation

@Observable
class ChallengeViewModel {
    
    enum Phase: Equatable {
        case countdown(Int) // 3, 2, 1
        case go
        case playing
        case roundResult(ChallengeMatch.RoundResult.Winner)
        case finished
    }
    
    private(set) var phase: Phase = .countdown(3)
    private(set) var match: ChallengeMatch
    private(set) var currentQuestion: MultipleChoiceStep?
    private(set) var shuffledOptions: [MCOption] = []
    
    // Per-round state
    private(set) var player1Locked: Bool = false
    private(set) var player2Locked: Bool = false
    private(set) var player1SelectedId: String?
    private(set) var player2SelectedId: String?
    private(set) var roundWinner: ChallengeMatch.RoundResult.Winner?
    
    private var questions: [MultipleChoiceStep] = []
    private var usedQuestionIds: Set<String> = []
    
    init(player1Name: String, player2Name: String, course: Course) {
        self.match = ChallengeMatch(
            player1Name: player1Name,
            player2Name: player2Name,
            totalRounds: 5
        )
        
        // Collect all MC steps from all lessons in the course
        let allSteps = course.sections
            .flatMap { $0.lessons }
            .flatMap { $0.steps }
            .compactMap { step -> MultipleChoiceStep? in
                if case .multipleChoice(let mc) = step { return mc }
                return nil
            }
        
        self.questions = allSteps.shuffled()
    }
    
    // MARK: - Countdown
    
    func startCountdown() {
        phase = .countdown(3)
        countdownTick()
    }
    
    private func countdownTick() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self else { return }
            switch self.phase {
            case .countdown(let n):
                if n > 1 {
                    self.phase = .countdown(n - 1)
                    self.countdownTick()
                } else {
                    self.phase = .go
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.startRound()
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Round
    
    private func startRound() {
        player1Locked = false
        player2Locked = false
        player1SelectedId = nil
        player2SelectedId = nil
        roundWinner = nil
        
        // Pick next question
        if let question = nextQuestion() {
            currentQuestion = question
            // Shuffle options
            var rng = SeededRandomNumberGenerator(seed: question.id.hashValue &+ match.currentRound)
            shuffledOptions = question.options.shuffled(using: &rng)
            phase = .playing
        } else {
            // No more questions — end early
            phase = .finished
        }
    }
    
    private func nextQuestion() -> MultipleChoiceStep? {
        // Try unused first
        if let q = questions.first(where: { !usedQuestionIds.contains($0.id) }) {
            usedQuestionIds.insert(q.id)
            return q
        }
        // Allow repeats if exhausted
        usedQuestionIds.removeAll()
        questions.shuffle()
        if let q = questions.first {
            usedQuestionIds.insert(q.id)
            return q
        }
        return nil
    }
    
    // MARK: - Player Actions
    
    func playerTap(player: Int, optionId: String) {
        guard phase == .playing, let question = currentQuestion else { return }
        
        let isPlayer1 = player == 1
        
        // Check if this player is locked out
        if isPlayer1 && player1Locked { return }
        if !isPlayer1 && player2Locked { return }
        
        let isCorrect = optionId == question.correctOptionId
        
        if isPlayer1 {
            player1SelectedId = optionId
        } else {
            player2SelectedId = optionId
        }
        
        if isCorrect {
            let winner: ChallengeMatch.RoundResult.Winner = isPlayer1 ? .player1 : .player2
            roundWinner = winner
            
            if isPlayer1 {
                match.player1Score += 1
            } else {
                match.player2Score += 1
            }
            match.roundResults.append(.init(winner: winner))
            
            phase = .roundResult(winner)
            advanceAfterDelay()
        } else {
            // Lock this player out
            if isPlayer1 {
                player1Locked = true
            } else {
                player2Locked = true
            }
            
            // Both locked = nobody scores
            if player1Locked && player2Locked {
                roundWinner = .none
                match.roundResults.append(.init(winner: .none))
                phase = .roundResult(.none)
                advanceAfterDelay()
            }
        }
    }
    
    private func advanceAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self else { return }
            if self.match.isFinished {
                self.phase = .finished
            } else {
                self.startRound()
            }
        }
    }
    
    // MARK: - Helpers
    
    func optionState(player: Int, optionId: String) -> OptionState {
        guard let question = currentQuestion else { return .idle }
        let selectedId = player == 1 ? player1SelectedId : player2SelectedId
        let isLocked = player == 1 ? player1Locked : player2Locked
        
        guard let selectedId else {
            return isLocked ? .disabled : .idle
        }
        
        if optionId == selectedId {
            let isCorrect = optionId == question.correctOptionId
            return isCorrect ? .correct : .wrong
        }
        
        // If round is over, show the correct answer
        if roundWinner != nil && optionId == question.correctOptionId {
            return .correctReveal
        }
        
        return isLocked ? .disabled : .idle
    }
    
    enum OptionState {
        case idle, correct, wrong, disabled, correctReveal
    }
    
    func rematch(course: Course) {
        match = ChallengeMatch(
            player1Name: match.player1Name,
            player2Name: match.player2Name,
            totalRounds: 5
        )
        usedQuestionIds.removeAll()
        
        let allSteps = course.sections
            .flatMap { $0.lessons }
            .flatMap { $0.steps }
            .compactMap { step -> MultipleChoiceStep? in
                if case .multipleChoice(let mc) = step { return mc }
                return nil
            }
        questions = allSteps.shuffled()
        
        startCountdown()
    }
}
