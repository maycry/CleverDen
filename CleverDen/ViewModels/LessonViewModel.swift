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
    private(set) var currentQuestionIndex: Int = 0
    private(set) var selectedAnswerId: String?
    private(set) var errorCount: Int = 0
    private(set) var isAnswerSubmitted: Bool = false
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    var currentQuestion: Question {
        lesson.questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard !lesson.questions.isEmpty else { return 0.0 }
        // Progress is based on questions answered (currentQuestionIndex + 1 if answer submitted)
        let questionsAnswered = isAnswerSubmitted ? currentQuestionIndex + 1 : currentQuestionIndex
        return Double(questionsAnswered) / Double(lesson.questions.count)
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex >= lesson.questions.count - 1
    }
    
    func selectAnswer(_ answerId: String) {
        guard !isAnswerSubmitted else { return }
        selectedAnswerId = answerId
    }
    
    func submitAnswer() {
        guard let selectedId = selectedAnswerId, !isAnswerSubmitted else { return }
        isAnswerSubmitted = true
        
        if selectedId != currentQuestion.correctAnswerId {
            errorCount += 1
        }
    }
    
    func isAnswerCorrect(_ answerId: String) -> Bool {
        answerId == currentQuestion.correctAnswerId
    }
    
    func moveToNextQuestion() {
        guard isAnswerSubmitted else { return }
        
        if !isLastQuestion {
            currentQuestionIndex += 1
            selectedAnswerId = nil
            isAnswerSubmitted = false
        }
    }
    
    func getDiamondsEarned() -> Int {
        if errorCount == 0 {
            return 3
        } else if errorCount <= 2 {
            return 2
        } else {
            return 1
        }
    }
    
    func getCoinsEarned() -> Int {
        if errorCount == 0 {
            return 75
        } else if errorCount <= 2 {
            return 50
        } else {
            return 25
        }
    }
}
