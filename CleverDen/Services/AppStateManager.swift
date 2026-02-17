//
//  AppStateManager.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation
import Observation

@Observable
class AppStateManager {
    let persistenceService: PersistenceService
    var userProgress: UserProgress
    
    init(persistenceService: PersistenceService = PersistenceService()) {
        self.persistenceService = persistenceService
        self.userProgress = persistenceService.loadProgress()
    }
    
    func saveProgress() {
        persistenceService.saveProgress(userProgress)
    }
    
    func updateProgress(_ update: (UserProgress) -> Void) {
        update(userProgress)
        saveProgress()
    }
    
    func resetProgress() {
        persistenceService.clearProgress()
        userProgress.completedLessons = [:]
        userProgress.currentLessonId = nil
    }
}
