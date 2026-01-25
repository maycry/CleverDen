//
//  SampleData.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

struct SampleData {
    static func createSections() -> [Section] {
        return [
            createSection1(),
            createSection2(),
            createSection3()
        ]
    }
    
    private static func createSection1() -> Section {
        let lessons = (1...10).map { lessonNumber in
            createLesson(
                id: "section1-lesson\(lessonNumber)",
                title: lessonNumber <= 5 ? "Continents p. \(lessonNumber)" : "Europe flags p. \(lessonNumber - 5)",
                sectionId: "section1",
                order: lessonNumber,
                iconName: lessonNumber <= 5 ? "globe" : "flag",
                questionCount: 6
            )
        }
        
        return Section(
            id: "section1",
            number: 1,
            title: "Continents",
            lessons: lessons
        )
    }
    
    private static func createSection2() -> Section {
        let lessons = (1...10).map { lessonNumber in
            createLesson(
                id: "section2-lesson\(lessonNumber)",
                title: lessonNumber <= 5 ? "North America flags p. \(lessonNumber)" : "South America flags p. \(lessonNumber - 5)",
                sectionId: "section2",
                order: lessonNumber,
                iconName: "flag",
                questionCount: 6
            )
        }
        
        return Section(
            id: "section2",
            number: 2,
            title: "North and South America",
            lessons: lessons
        )
    }
    
    private static func createSection3() -> Section {
        let lessons = (1...10).map { lessonNumber in
            createLesson(
                id: "section3-lesson\(lessonNumber)",
                title: lessonNumber <= 5 ? "Europe flags p. \(lessonNumber)" : "Asia flags p. \(lessonNumber - 5)",
                sectionId: "section3",
                order: lessonNumber,
                iconName: "flag",
                questionCount: 6
            )
        }
        
        return Section(
            id: "section3",
            number: 3,
            title: "Europe and Asia",
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
