//
//  CourseDataLoader.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 2/15/26.
//

import Foundation

struct CourseDataLoader {
    
    private static let courseFiles = ["flags", "capitals"]
    
    static func loadAllCourses() -> [Course] {
        return courseFiles.compactMap { loadCourse(named: $0) }
    }
    
    static func loadCourse(named filename: String) -> Course? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("CourseDataLoader: Could not find \(filename).json in bundle")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let courseData = try decoder.decode(CourseJSON.self, from: data)
            return courseData.toCourse()
        } catch {
            print("CourseDataLoader: Failed to decode \(filename).json — \(error)")
            return nil
        }
    }
}

// MARK: - JSON Decodable Structures

private struct CourseJSON: Decodable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let color: String
    let sections: [SectionJSON]
    
    func toCourse() -> Course {
        let mappedSections = sections.map { section in
            section.toSection(courseId: id)
        }
        return Course(
            id: id,
            title: title,
            subtitle: subtitle,
            iconName: iconName,
            color: color,
            sections: mappedSections
        )
    }
}

private struct SectionJSON: Decodable {
    let id: String
    let number: Int
    let title: String
    let lessons: [LessonJSON]
    
    func toSection(courseId: String) -> Section {
        let mappedLessons = lessons.map { lesson in
            lesson.toLesson(sectionId: id)
        }
        return Section(
            id: id,
            courseId: courseId,
            number: number,
            title: title,
            lessons: mappedLessons
        )
    }
}

private struct LessonJSON: Decodable {
    let id: String
    let title: String
    let order: Int
    let iconName: String
    let steps: [LessonStep]
    
    func toLesson(sectionId: String) -> Lesson {
        return Lesson(
            id: id,
            title: title,
            sectionId: sectionId,
            order: order,
            iconName: iconName,
            steps: steps
        )
    }
}
