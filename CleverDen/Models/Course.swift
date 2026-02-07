//
//  Course.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 2/7/26.
//

import Foundation

struct Course: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String // SF Symbol name
    let color: String // Hex color string (e.g., "FF5A35")
    let sections: [Section]
    
    var totalSectionsCount: Int {
        return sections.count
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
}
