//
//  CourseView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct LessonNavigationItem: Identifiable {
    let id: String
    let lesson: Lesson
}

struct CourseView: View {
    @State private var viewModel = CourseViewModel()
    @State private var selectedTab: FloatingNavBar.Tab = .home
    @State private var scrollOffset: CGFloat = 0
    @State private var currentSectionId: String?
    @State private var scrollToLessonId: String?
    @State private var selectedLessonItem: LessonNavigationItem?
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            if selectedTab == .home {
                // Main Content - Full Screen ScrollView
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: .spacingXL) {
                            ForEach(viewModel.sections) { section in
                                SectionView(
                                    section: section,
                                    viewModel: viewModel,
                                    scrollToLessonId: $scrollToLessonId,
                                    onLessonTap: { lesson in
                                        selectedLessonItem = LessonNavigationItem(id: lesson.id, lesson: lesson)
                                    }
                                )
                                .id(section.id)
                            }
                        }
                        .padding(.horizontal, .screenPadding)
                        .padding(.top, .spacingXXL + .spacingXXL + 10) // Space for top nav bar
                        .padding(.bottom, 100) // Space for floating nav bar
                    }
                    .onChange(of: scrollToLessonId) { oldValue, newValue in
                        if let lessonId = newValue {
                            scrollToLesson(lessonId: lessonId, proxy: proxy)
                        }
                    }
                }
                .overlay(alignment: .top) {
                    TopNavigationBar(coins: viewModel.userProgress.coins)
                }
                .overlay(alignment: .bottom) {
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
        .fullScreenCover(item: $selectedLessonItem) { item in
            LessonFlowView(
                lesson: item.lesson,
                userProgress: $viewModel.userProgress,
                onDismiss: {
                    selectedLessonItem = nil
                },
                onComplete: {
                    selectedLessonItem = nil
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

// Wrapper view that manages the transition from LessonView to LessonCompleteView
// This ensures SwiftUI treats it as a single presentation throughout
struct LessonFlowView: View {
    let lesson: Lesson
    @Binding var userProgress: UserProgress
    let onDismiss: () -> Void
    let onComplete: () -> Void
    
    @State private var showCompletion = false
    @State private var errorCount = 0
    
    var body: some View {
        ZStack {
            // Background color to prevent black flash during transition
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            if showCompletion {
                LessonCompleteView(
                    lesson: lesson,
                    errorCount: errorCount,
                    userProgress: $userProgress,
                    onContinue: onComplete
                )
                .transition(.opacity)
            } else {
                LessonView(
                    lesson: lesson,
                    userProgress: $userProgress,
                    onDismiss: onDismiss,
                    onComplete: { count in
                        errorCount = count
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCompletion = true
                        }
                    }
                )
                .transition(.opacity)
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
