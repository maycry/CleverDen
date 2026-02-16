//
//  SampleData.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import Foundation

struct SampleData {
    static func createCourses() -> [Course] {
        return CourseDataLoader.loadAllCourses()
    }
}
