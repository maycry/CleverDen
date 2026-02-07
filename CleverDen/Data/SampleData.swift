//
//  SampleData.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

struct SampleData {
    static func createCourses() -> [Course] {
        return [
            createFlagsCourse(),
            createContinentsCourse(),
            createUnitedStatesCourse(),
            createCapitalsCourse()
        ]
    }
    
    // MARK: - Flags Course (8 sections)
    private static func createFlagsCourse() -> Course {
        let sections = (1...8).map { sectionNumber in
            createSection(
                id: "flags-section\(sectionNumber)",
                courseId: "flags",
                number: sectionNumber,
                title: "Flags Section \(sectionNumber)",
                lessonPrefix: "Flags",
                iconName: "flag"
            )
        }
        
        return Course(
            id: "flags",
            title: "Flags",
            subtitle: "Starting learning flags of the world.",
            iconName: "flag.fill",
            color: "FF5A35",
            sections: sections
        )
    }
    
    // MARK: - Continents Course (3 sections)
    private static func createContinentsCourse() -> Course {
        let sections = (1...3).map { sectionNumber in
            createSection(
                id: "continents-section\(sectionNumber)",
                courseId: "continents",
                number: sectionNumber,
                title: "Continents Section \(sectionNumber)",
                lessonPrefix: "Continents",
                iconName: "globe"
            )
        }
        
        return Course(
            id: "continents",
            title: "Continents",
            subtitle: "Learn the continents of the world.",
            iconName: "globe",
            color: "FFFFFF",
            sections: sections
        )
    }
    
    // MARK: - United States Course (5 sections)
    private static func createUnitedStatesCourse() -> Course {
        let sections = (1...5).map { sectionNumber in
            createSection(
                id: "united-states-section\(sectionNumber)",
                courseId: "united-states",
                number: sectionNumber,
                title: "United States Section \(sectionNumber)",
                lessonPrefix: "US States",
                iconName: "flag"
            )
        }
        
        return Course(
            id: "united-states",
            title: "United States",
            subtitle: "Learn the states of the USA.",
            iconName: "flag.fill",
            color: "F8C429",
            sections: sections
        )
    }
    
    // MARK: - Capitals Course (6 sections)
    private static func createCapitalsCourse() -> Course {
        let sections = (1...6).map { sectionNumber in
            createSection(
                id: "capitals-section\(sectionNumber)",
                courseId: "capitals",
                number: sectionNumber,
                title: "Capitals Section \(sectionNumber)",
                lessonPrefix: "Capitals",
                iconName: "building.2"
            )
        }
        
        return Course(
            id: "capitals",
            title: "Capitals",
            subtitle: "Learn the capitals of the world.",
            iconName: "building.2.fill",
            color: "FF9D57",
            sections: sections
        )
    }
    
    // MARK: - Section Helper
    private static func createSection(
        id: String,
        courseId: String,
        number: Int,
        title: String,
        lessonPrefix: String,
        iconName: String
    ) -> Section {
        let lessons = (1...10).map { lessonNumber in
            createLesson(
                id: "\(id)-lesson\(lessonNumber)",
                title: "\(lessonPrefix) p. \(lessonNumber)",
                sectionId: id,
                order: lessonNumber,
                iconName: iconName,
                questionCount: 6
            )
        }
        
        return Section(
            id: id,
            courseId: courseId,
            number: number,
            title: title,
            lessons: lessons
        )
    }
    
    private static func createLesson(
        id: String,
        title: String,
        sectionId: String,
        order: Int,
        iconName: String,
        questionCount: Int
    ) -> Lesson {
        let questions = (1...questionCount).map { questionNum in
            createQuestion(
                id: "\(id)-q\(questionNum)",
                questionNum: questionNum,
                lessonTitle: title
            )
        }
        
        return Lesson(
            id: id,
            title: title,
            sectionId: sectionId,
            order: order,
            iconName: iconName,
            questions: questions
        )
    }
    
    private static func createQuestion(
        id: String,
        questionNum: Int,
        lessonTitle: String
    ) -> Question {
        // Sample questions about continents and flags
        let questionTemplates = [
            ("What is the largest continent on Earth?", ["Canada", "Asia", "Europe", "North America"], "Asia"),
            ("Which continent is known as the 'Dark Continent'?", ["Africa", "Asia", "Australia", "Antarctica"], "Africa"),
            ("How many continents are there?", ["5", "6", "7", "8"], "7"),
            ("Which continent is the smallest?", ["Australia", "Europe", "Antarctica", "South America"], "Australia"),
            ("Which continent is home to the Amazon rainforest?", ["Africa", "South America", "Asia", "North America"], "South America"),
            ("What is the coldest continent?", ["Europe", "Antarctica", "North America", "Asia"], "Antarctica")
        ]
        
        let templateIndex = (questionNum - 1) % questionTemplates.count
        let template = questionTemplates[templateIndex]
        
        let answers = template.1.enumerated().map { index, text in
            Answer(id: "\(id)-a\(index + 1)", text: text)
        }
        
        let correctAnswerId = answers.first { $0.text == template.2 }?.id ?? answers[0].id
        
        return Question(
            id: id,
            text: template.0,
            answers: answers,
            correctAnswerId: correctAnswerId
        )
    }
}
