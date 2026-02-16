//
//  LessonViewModel.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation
import Observation

@Observable
class LessonViewModel {
    let lesson: Lesson
    private(set) var currentStepIndex: Int = 0
    private(set) var totalErrors: Int = 0
    private(set) var isStepComplete: Bool = false
    private(set) var feedbackMode: FeedbackMode?
    
    // MARK: - Multiple Choice State
    private(set) var selectedOptionId: String?
    
    // MARK: - Match Pairs State
    private(set) var selectedLeftId: String?
    private(set) var selectedRightId: String?
    private(set) var matchedPairIds: Set<String> = []
    private(set) var wrongLeftId: String?
    private(set) var wrongRightId: String?
    private(set) var matchPairsErrorCount: Int = 0
    private let maxMatchPairsErrors = 3
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    var currentStep: LessonStep {
        lesson.steps[currentStepIndex]
    }
    
    var progress: Double {
        guard !lesson.steps.isEmpty else { return 0.0 }
        let stepsCompleted = isStepComplete ? currentStepIndex + 1 : currentStepIndex
        return Double(stepsCompleted) / Double(lesson.steps.count)
    }
    
    var isLastStep: Bool {
        currentStepIndex >= lesson.steps.count - 1
    }
    
    // MARK: - Multiple Choice
    
    func selectOption(_ optionId: String) {
        guard case .multipleChoice = currentStep, !isStepComplete else { return }
        selectedOptionId = optionId
    }
    
    func submitOption() {
        guard case .multipleChoice(let step) = currentStep,
              let selectedId = selectedOptionId,
              !isStepComplete else { return }
        
        isStepComplete = true
        let correct = selectedId == step.correctOptionId
        if !correct {
            totalErrors += 1
        }
        feedbackMode = correct ? .correct : .incorrectFinal
    }
    
    func isMCOptionCorrect(_ optionId: String) -> Bool? {
        guard case .multipleChoice(let step) = currentStep, isStepComplete else { return nil }
        if optionId == step.correctOptionId { return true }
        if optionId == selectedOptionId { return false }
        return nil
    }
    
    // MARK: - Match Pairs
    
    func selectMatchItem(column: MatchColumn, id: String) {
        guard case .matchPairs = currentStep, !isStepComplete else { return }
        
        // Clear wrong state
        wrongLeftId = nil
        wrongRightId = nil
        
        // Skip already matched items
        if matchedPairIds.contains(id) { return }
        
        switch column {
        case .left:
            if selectedRightId != nil {
                // We have a right selected, this completes a guess
                checkMatch(leftId: id, rightId: selectedRightId!)
            } else {
                selectedLeftId = id
            }
        case .right:
            if selectedLeftId != nil {
                // We have a left selected, this completes a guess
                checkMatch(leftId: selectedLeftId!, rightId: id)
            } else {
                selectedRightId = id
            }
        }
    }
    
    private func checkMatch(leftId: String, rightId: String) {
        guard case .matchPairs(let step) = currentStep else { return }
        
        let isCorrect = step.pairs.contains { pair in
            pair.left == leftId && pair.right == rightId
        }
        
        selectedLeftId = nil
        selectedRightId = nil
        
        if isCorrect {
            matchedPairIds.insert(leftId)
            matchedPairIds.insert(rightId)
            
            // Check if all pairs matched
            if matchedPairIds.count == step.pairs.count * 2 {
                isStepComplete = true
                feedbackMode = .correct
            }
        } else {
            totalErrors += 1
            matchPairsErrorCount += 1
            wrongLeftId = leftId
            wrongRightId = rightId
            
            if matchPairsErrorCount >= maxMatchPairsErrors {
                isStepComplete = true
                feedbackMode = .incorrectFinal
            } else {
                feedbackMode = .incorrectRetry
            }
        }
    }
    
    func retryMatchPairs() {
        wrongLeftId = nil
        wrongRightId = nil
        feedbackMode = nil
    }
    
    func matchItemState(_ id: String) -> MatchItemState {
        if matchedPairIds.contains(id) { return .matched }
        if id == wrongLeftId || id == wrongRightId { return .wrong }
        if id == selectedLeftId || id == selectedRightId { return .selected }
        return .idle
    }
    
    // MARK: - Navigation
    
    func moveToNextStep() {
        guard isStepComplete, !isLastStep else { return }
        
        currentStepIndex += 1
        resetStepState()
    }
    
    private func resetStepState() {
        isStepComplete = false
        feedbackMode = nil
        selectedOptionId = nil
        selectedLeftId = nil
        selectedRightId = nil
        matchedPairIds = []
        wrongLeftId = nil
        wrongRightId = nil
        matchPairsErrorCount = 0
    }
    
    func getDiamondsEarned() -> Int {
        if totalErrors == 0 {
            return 3
        } else if totalErrors <= 2 {
            return 2
        } else {
            return 1
        }
    }
    
    func getCoinsEarned() -> Int {
        if totalErrors == 0 {
            return 75
        } else if totalErrors <= 2 {
            return 50
        } else {
            return 25
        }
    }
}

enum MatchColumn {
    case left, right
}

enum MatchItemState: Equatable {
    case idle, selected, matched, wrong
}
