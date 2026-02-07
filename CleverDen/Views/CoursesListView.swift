//
//  CoursesListView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 2/7/26.
//

import SwiftUI

struct CoursesListView: View {
    @State private var viewModel = CoursesViewModel()
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // CleverDen Logo
                    Image("cleverDenLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130)
                        .padding(.top, .spacingXXL)
                        .padding(.bottom, .spacingXL)
                    
                    // Course Tiles
                    VStack(spacing: .spacingM) {
                        ForEach(viewModel.courses) { course in
                            NavigationLink(value: course) {
                                CourseTileCard(
                                    course: course,
                                    completedSections: viewModel.getCompletedSectionsCount(for: course.id)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, .tilePadding)
                    .padding(.bottom, .spacingXXL)
                }
            }
        }
        .navigationDestination(for: Course.self) { course in
            CourseDetailView(
                course: course,
                userProgress: $viewModel.userProgress
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        CoursesListView()
    }
}
