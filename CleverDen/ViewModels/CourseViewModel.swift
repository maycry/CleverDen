//
//  CourseViewModel.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation
import Observation

@Observable
class CourseViewModel {
    var sections: [Section] = []
    var userProgress: UserProgress
    private let persistenceService: PersistenceService
    
    init(persistenceService: PersistenceService = PersistenceService()) {
        self.persistenceService = persistenceService
        self.userProgress = persistenceService.loadProgress()
        loadSections()
    }
    
    private func loadSections() {
        sections = SampleData.createSections()
    }
    
    func getAllLessons() -> [Lesson] {
        sections.flatMap { $0.lessons }
    }
    
    func getLessonStatus(_ lesson: Lesson) -> Lesson.Status {
        userProgress.getLessonStatus(lesson, allLessons: getAllLessons())
    }
    
    func getNextAvailableLesson() -> Lesson? {
        let allLessons = getAllLessons()
        return allLessons.first { lesson in
            let status = getLessonStatus(lesson)
            return status == .available
        }
    }
    
    func saveProgress() {
        persistenceService.saveProgress(userProgress)
    }
}
