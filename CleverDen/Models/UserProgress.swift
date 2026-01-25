//
//  UserProgress.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation
import Observation

@Observable
class UserProgress {
    var coins: Int = 0
    var completedLessons: [String: Int] = [:] // lessonId: diamondsEarned
    var currentLessonId: String?
    
    func markLessonComplete(lessonId: String, diamonds: Int, coinsEarned: Int) {
        completedLessons[lessonId] = diamonds
        coins += coinsEarned
    }
    
    func getLessonStatus(_ lesson: Lesson, allLessons: [Lesson]) -> Lesson.Status {
        // Check if lesson is completed
        if let diamonds = completedLessons[lesson.id] {
            return .completed(diamonds: diamonds)
        }
        
        // Check if previous lesson in the same section is completed
        let sectionLessons = allLessons.filter { $0.sectionId == lesson.sectionId }
            .sorted { $0.order < $1.order }
        
        if let currentIndex = sectionLessons.firstIndex(where: { $0.id == lesson.id }) {
            // First lesson in section is always available
            if currentIndex == 0 {
                return .available
            }
            
            // Check if previous lesson is completed
            let previousLesson = sectionLessons[currentIndex - 1]
            if completedLessons[previousLesson.id] != nil {
                return .available
            }
        }
        
        return .locked
    }
}
