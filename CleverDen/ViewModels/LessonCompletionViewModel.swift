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
    let starsEarned: Int
    
    init(lesson: Lesson, errorCount: Int) {
        self.lesson = lesson
        self.errorCount = errorCount
        self.starsEarned = Self.calculateStars(errorCount: errorCount)
    }
    
    static func calculateStars(errorCount: Int) -> Int {
        if errorCount == 0 {
            return 3
        } else if errorCount <= 2 {
            return 2
        } else {
            return 1
        }
    }
}
