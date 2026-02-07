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
    let course: Course
    var sections: [Section] = []
    var userProgress: UserProgress
    private let persistenceService: PersistenceService
    
    init(course: Course, userProgress: UserProgress, persistenceService: PersistenceService = PersistenceService()) {
        self.course = course
        self.userProgress = userProgress
        self.persistenceService = persistenceService
        loadSections()
    }
    
    private func loadSections() {
        // Filter sections to only show those belonging to this course
        sections = course.sections.filter { $0.courseId == course.id }
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
