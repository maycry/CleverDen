//
//  PersistenceService.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

class PersistenceService {
    private let userDefaults = UserDefaults.standard
    private let completedLessonsKey = "completedLessons"
    private let currentLessonIdKey = "currentLessonId"
    
    func saveProgress(_ progress: UserProgress) {
        userDefaults.set(progress.completedLessons, forKey: completedLessonsKey)
        if let currentLessonId = progress.currentLessonId {
            userDefaults.set(currentLessonId, forKey: currentLessonIdKey)
        }
    }
    
    func loadProgress() -> UserProgress {
        let progress = UserProgress()
        
        if let completedLessons = userDefaults.dictionary(forKey: completedLessonsKey) as? [String: Int] {
            progress.completedLessons = completedLessons
        }
        
        if let currentLessonId = userDefaults.string(forKey: currentLessonIdKey) {
            progress.currentLessonId = currentLessonId
        }
        
        return progress
    }
    
    func clearProgress() {
        userDefaults.removeObject(forKey: completedLessonsKey)
        userDefaults.removeObject(forKey: currentLessonIdKey)
    }
}
