//
//  CoursesViewModel.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 2/7/26.
//

import Foundation
import Observation

@Observable
class CoursesViewModel {
    var courses: [Course] = []
    var userProgress: UserProgress
    private let persistenceService: PersistenceService
    
    init() {
        self.persistenceService = PersistenceService()
        self.userProgress = persistenceService.loadProgress()
        loadCourses()
    }
    
    private func loadCourses() {
        courses = SampleData.createCourses()
    }
    
    func getCompletedSectionsCount(for courseId: String) -> Int {
        let allSections = courses.flatMap { $0.sections }
        return userProgress.getCompletedSectionsCount(for: courseId, allSections: allSections)
    }
    
    func saveProgress() {
        persistenceService.saveProgress(userProgress)
    }
}
