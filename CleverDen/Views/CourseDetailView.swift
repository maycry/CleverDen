//
//  CourseDetailView.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/25/26.
//

import SwiftUI

struct LessonNavigationItem: Identifiable {
    let id: String
    let lesson: Lesson
}

struct CourseDetailView: View {
    let course: Course
    @Binding var userProgress: UserProgress
    @State private var viewModel: CourseViewModel
    @State private var selectedTab: FloatingNavBar.Tab = .home
    @State private var scrollOffset: CGFloat = 0
    @State private var currentSectionId: String?
    @State private var scrollToLessonId: String?
    @State private var selectedLessonItem: LessonNavigationItem?
    @Environment(\.dismiss) private var dismiss
    
    init(course: Course, userProgress: Binding<UserProgress>) {
        self.course = course
        self._userProgress = userProgress
        self._viewModel = State(initialValue: CourseViewModel(course: course, userProgress: userProgress.wrappedValue))
    }
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            if selectedTab == .home {
                // Main Content - Full Screen ScrollView with Sticky Headers
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            ForEach(viewModel.sections) { section in
                                SwiftUI.Section {
                                    // Lesson Pills in Zig-Zag Layout
                                    ZigZagLessonsLayout(
                                        lessons: section.lessons,
                                        viewModel: viewModel,
                                        onLessonTap: { lesson in
                                            selectedLessonItem = LessonNavigationItem(id: lesson.id, lesson: lesson)
                                        }
                                    )
                                    .padding(.top, .spacingXL)
                                    .padding(.horizontal, .screenPaddingXL)
                                    .padding(.bottom, .spacingXL)
                                } header: {
                                    SectionHeader(section: section)
                                        .padding(.horizontal, .screenPadding)
                                        .padding(.top, .spacingXXL + .spacingXXL)
                                }
                                .id(section.id)
                            }
                        }
                    
                
                    }
                    .onChange(of: scrollToLessonId) { oldValue, newValue in
                        if let lessonId = newValue {
                            scrollToLesson(lessonId: lessonId, proxy: proxy)
                        }
                    }
                }
                .overlay(alignment: .bottom) {
                    FloatingNavBar(selectedTab: $selectedTab)
                }
                .overlay(alignment: .top) {
                    // Custom header with back button, course title, and coins
                    ZStack {
                        // Title - truly centered
                        Text(course.title)
                            .font(.headlineMedium)
                            .foregroundColor(.textPrimary)
                        
                        // Left and right elements
                        HStack {
                            // Back button with grid icon
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "square.grid.2x2")
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(.textSecondary)
                                    .frame(width: 44, height: 44)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, .screenPadding)
                    .padding(.bottom, .spacingM)
                    .background(
                        Color.backgroundSecondary
                            .ignoresSafeArea(edges: .top)
                    )
                }
            } else {
                ProfileView(userProgress: viewModel.userProgress) {
                        viewModel.userProgress.completedLessons = [:]
                        viewModel.userProgress.currentLessonId = nil
                        viewModel.saveProgress()
                    }
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

// Zig-Zag layout for lessons
struct ZigZagLessonsLayout: View {
    let lessons: [Lesson]
    let viewModel: CourseViewModel
    let onLessonTap: (Lesson) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                let status = viewModel.getLessonStatus(lesson)
                let isNextLesson = viewModel.getNextAvailableLesson()?.id == lesson.id
                let isEven = index % 2 == 0
                
                HStack {
                    if !isEven {
                        Spacer()
                    }
                    
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
                    
                    if isEven {
                        Spacer()
                    }
                }
                
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
            
            // Lesson view - slides left when removed
            if !showCompletion {
                LessonView(
                    lesson: lesson,
                    userProgress: $userProgress,
                    onDismiss: onDismiss,
                    onComplete: { count in
                        errorCount = count
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showCompletion = true
                        }
                    }
                )
                .transition(.move(edge: .leading))
                .zIndex(showCompletion ? 0 : 1)
            }
            
            // Complete view - slides from right when inserted
            if showCompletion {
                LessonCompleteView(
                    lesson: lesson,
                    errorCount: errorCount,
                    userProgress: $userProgress,
                    onContinue: onComplete
                )
                .transition(.move(edge: .trailing))
                .zIndex(showCompletion ? 1 : 0)
            }
        }
    }
}
