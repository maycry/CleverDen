//
//  CourseView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct CourseView: View {
    @State private var viewModel = CourseViewModel()
    @State private var selectedTab: FloatingNavBar.Tab = .home
    @State private var scrollOffset: CGFloat = 0
    @State private var currentSectionId: String?
    @State private var scrollToLessonId: String?
    @State private var selectedLesson: Lesson?
    @State private var completedLessonData: CompletedLessonData?
    
    struct CompletedLessonData: Identifiable {
        let id: String
        let lesson: Lesson
        let errorCount: Int
    }
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            if selectedTab == .home {
                VStack(spacing: 0) {
                    // Top Navigation Bar
                    TopNavigationBar(coins: viewModel.userProgress.coins)
                    
                    // Main Content
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: .spacingXL) {
                                ForEach(viewModel.sections) { section in
                                    SectionView(
                                        section: section,
                                        viewModel: viewModel,
                                        scrollToLessonId: $scrollToLessonId,
                                        onLessonTap: { lesson in
                                            selectedLesson = lesson
                                        }
                                    )
                                    .id(section.id)
                                }
                            }
                            .padding(.horizontal, .screenPadding)
                            .padding(.top, .spacingM)
                            .padding(.bottom, 100) // Space for floating nav bar
                        }
                        .onChange(of: scrollToLessonId) { oldValue, newValue in
                            if let lessonId = newValue {
                                scrollToLesson(lessonId: lessonId, proxy: proxy)
                            }
                        }
                    }
                    
                    // Floating Navigation Bar
                    FloatingNavBar(selectedTab: $selectedTab)
                }
            } else {
                ProfileView(userProgress: viewModel.userProgress)
                    .overlay(alignment: .bottom) {
                        FloatingNavBar(selectedTab: $selectedTab)
                    }
            }
        }
        .onAppear {
            // Auto-scroll to next lesson after a brief delay to ensure view is rendered
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let nextLesson = viewModel.getNextAvailableLesson() {
                    scrollToLessonId = nextLesson.id
                }
            }
        }
        .fullScreenCover(item: $selectedLesson) { lesson in
            LessonView(
                lesson: lesson,
                userProgress: $viewModel.userProgress,
                onDismiss: {
                    selectedLesson = nil
                },
                onComplete: { errorCount in
                    selectedLesson = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        completedLessonData = CompletedLessonData(
                            id: lesson.id,
                            lesson: lesson,
                            errorCount: errorCount
                        )
                    }
                }
            )
        }
        .fullScreenCover(item: $completedLessonData) { data in
            LessonCompleteView(
                lesson: data.lesson,
                errorCount: data.errorCount,
                userProgress: $viewModel.userProgress,
                onContinue: {
                    completedLessonData = nil
                    viewModel.saveProgress()
                    
                    // Auto-scroll to next lesson
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let nextLesson = viewModel.getNextAvailableLesson() {
                            scrollToLessonId = nextLesson.id
                        }
                    }
                }
            )
        }
    }
    
    private func scrollToLesson(lessonId: String, proxy: ScrollViewProxy) {
        // Find the section containing this lesson
        if let section = viewModel.sections.first(where: { section in
            section.lessons.contains { $0.id == lessonId }
        }) {
            withAnimation(.easeInOut(duration: 0.5)) {
                proxy.scrollTo(section.id, anchor: .top)
            }
        }
    }
}

struct SectionView: View {
    let section: Section
    let viewModel: CourseViewModel
    @Binding var scrollToLessonId: String?
    let onLessonTap: (Lesson) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: .spacingL) {
            // Section Header
            SectionHeader(section: section)
                .id("header-\(section.id)")
            
            // Lesson Pills
            VStack(spacing: .spacingM) {
                ForEach(section.lessons) { lesson in
                    let status = viewModel.getLessonStatus(lesson)
                    let isNextLesson = viewModel.getNextAvailableLesson()?.id == lesson.id
                    
                    Button(action: {
                        if status != .locked {
                            onLessonTap(lesson)
                        }
                    }) {
                        LessonPill(
                            lesson: lesson,
                            status: status,
                            isNextLesson: isNextLesson
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(LessonPillButtonStyle())
                    .disabled(status == .locked)
                    .id(lesson.id)
                }
            }
        }
    }
}
