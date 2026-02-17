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
    var completedLessons: [String: Int] = [:] // lessonId: stars earned (1-3)
    var currentLessonId: String?
    
    func markLessonComplete(lessonId: String, stars: Int) {
        // Only update if new stars are better than existing
        if let existing = completedLessons[lessonId], existing >= stars {
            return
        }
        completedLessons[lessonId] = stars
    }
    
    func getLessonStatus(_ lesson: Lesson, allLessons: [Lesson], allSections: [Section]) -> Lesson.Status {
        // Check if lesson is completed
        if let stars = completedLessons[lesson.id] {
            return .completed(stars: stars)
        }
        
        // Find the section this lesson belongs to
        let sectionLessons = allLessons.filter { $0.sectionId == lesson.sectionId }
            .sorted { $0.order < $1.order }
        
        if let currentIndex = sectionLessons.firstIndex(where: { $0.id == lesson.id }) {
            // First lesson in section
            if currentIndex == 0 {
                // First lesson of first section is always available
                guard let section = allSections.first(where: { $0.id == lesson.sectionId }) else {
                    return .available
                }
                
                // Check if this is the first section
                let sortedSections = allSections.sorted { $0.number < $1.number }
                if section.id == sortedSections.first?.id {
                    return .available
                }
                
                // For other sections: available if previous section is fully completed
                if let sectionIndex = sortedSections.firstIndex(where: { $0.id == section.id }),
                   sectionIndex > 0 {
                    let previousSection = sortedSections[sectionIndex - 1]
                    let allPreviousCompleted = previousSection.lessons.allSatisfy { completedLessons[$0.id] != nil }
                    return allPreviousCompleted ? .available : .locked
                }
                
                return .locked
            }
            
            // Not first lesson: available if previous lesson in section is completed
            let previousLesson = sectionLessons[currentIndex - 1]
            if completedLessons[previousLesson.id] != nil {
                return .available
            }
        }
        
        return .locked
    }
    
    func getCompletedSectionsCount(for courseId: String, allSections: [Section]) -> Int {
        let courseSections = allSections.filter { $0.courseId == courseId }
        return courseSections.filter { section in
            section.lessons.allSatisfy { completedLessons[$0.id] != nil }
        }.count
    }
}
