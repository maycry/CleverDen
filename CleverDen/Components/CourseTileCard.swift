//
//  CourseTileCard.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 2/7/26.
//

import SwiftUI

struct CourseTileCard: View {
    let course: Course
    let completedSections: Int
    
    private var tileColor: Color {
        Color(hex: course.color)
    }
    
    private var progressPercentage: Double {
        guard course.totalSectionsCount > 0 else { return 0 }
        return Double(completedSections) / Double(course.totalSectionsCount)
    }
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: .radiusTile)
                .fill(tileColor)
                .shadowMedium()
            
            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Main content with icon
                HStack(alignment: .top, spacing: .spacingM) {
                    // Text content
                    VStack(alignment: .leading, spacing: .spacingXS) {
                        Text(course.title)
                            .font(.headlineLarge)
                            .foregroundColor(course.color == "FFFFFF" ? .textPrimary : .textInverted)
                        
                        Text(course.subtitle)
                            .font(.body)
                            .foregroundColor(course.color == "FFFFFF" ? .textSecondary : .textInverted.opacity(0.85))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    // Icon
                    Image(systemName: course.iconName)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(course.color == "FFFFFF" ? .textPrimary.opacity(0.3) : .textInverted.opacity(0.3))
                }
                
                Spacer()
                
                // Bottom section count
                Text("\(course.totalSectionsCount) sections")
                    .font(.bodyLarge)
                    .fontWeight(.bold)
                    .foregroundColor(course.color == "FFFFFF" ? .textPrimary : .textInverted)
                
                // Progress bar (only if started)
                if completedSections > 0 {
                    ProgressBar(progress: progressPercentage)
                        .frame(height: 8)
                        .padding(.top, .spacingS)
                }
            }
            .padding(.horizontal, .tileInnerPaddingH)
            .padding(.vertical, .tileInnerPaddingV)
        }
        .frame(height: 170)
    }
}

#Preview("Flags Course - Not Started") {
    CourseTileCard(
        course: Course(
            id: "flags",
            title: "Flags",
            subtitle: "Starting learning flags of the world.",
            iconName: "flag.fill",
            color: "FF5A35",
            sections: []
        ),
        completedSections: 0
    )
    .padding(.tilePadding)
}

#Preview("Continents Course - In Progress") {
    CourseTileCard(
        course: Course(
            id: "continents",
            title: "Continents",
            subtitle: "Learn the continents of the world.",
            iconName: "globe",
            color: "FFFFFF",
            sections: []
        ),
        completedSections: 2
    )
    .padding(.tilePadding)
}
