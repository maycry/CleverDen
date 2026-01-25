//
//  LessonCompletionViewModel.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation
import Observation

@Observable
class LessonCompletionViewModel {
    let lesson: Lesson
    let errorCount: Int
    let diamondsEarned: Int
    let coinsEarned: Int
    
    init(lesson: Lesson, errorCount: Int) {
        self.lesson = lesson
        self.errorCount = errorCount
        self.diamondsEarned = Self.calculateDiamonds(errorCount: errorCount)
        self.coinsEarned = Self.calculateCoins(errorCount: errorCount)
    }
    
    static func calculateDiamonds(errorCount: Int) -> Int {
        if errorCount == 0 {
            return 3
        } else if errorCount <= 2 {
            return 2
        } else {
            return 1
        }
    }
    
    static func calculateCoins(errorCount: Int) -> Int {
        if errorCount == 0 {
            return 75
        } else if errorCount <= 2 {
            return 50
        } else {
            return 25
        }
    }
}
