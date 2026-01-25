# Clever Den Implementation Plan

This document provides a step-by-step guide for implementing the Clever Den iOS app. Follow this plan sequentially to build the app systematically.

## Prerequisites

- Xcode project set up with SwiftUI
- Design system rules loaded (`.cursor/rules/design-system.mdc`)
- Best practices rules loaded (`.cursor/rules/best-practices.mdc`, `.cursor/rules/views-best-practices.mdc`)

## Phase 1: Foundation & Data Models

### Step 1.1: Create Core Data Models

Create the following data structures:

**File: `Models/Lesson.swift`**
```swift
struct Lesson: Identifiable, Codable {
    let id: String
    let title: String
    let sectionId: String
    let order: Int
    let iconName: String // SF Symbol name or asset name
    let questions: [Question]
    
    enum Status {
        case locked
        case available
        case completed(diamonds: Int) // 1-3 diamonds earned
    }
}
```

**File: `Models/Section.swift`**
```swift
struct Section: Identifiable, Codable {
    let id: String
    let number: Int
    let title: String
    let lessons: [Lesson]
}
```

**File: `Models/Question.swift`**
```swift
struct Question: Identifiable, Codable {
    let id: String
    let text: String
    let answers: [Answer]
    let correctAnswerId: String
}

struct Answer: Identifiable, Codable {
    let id: String
    let text: String
}
```

**File: `Models/UserProgress.swift`**
```swift
@Observable
class UserProgress {
    var coins: Int = 0
    var completedLessons: [String: Int] = [:] // lessonId: diamondsEarned
    var currentLessonId: String?
    
    func markLessonComplete(lessonId: String, diamonds: Int, coinsEarned: Int) {
        completedLessons[lessonId] = diamonds
        coins += coinsEarned
    }
    
    func getLessonStatus(_ lesson: Lesson) -> Lesson.Status {
        if let diamonds = completedLessons[lesson.id] {
            return .completed(diamonds: diamonds)
        }
        // Check if previous lesson is completed
        // Logic to determine .locked vs .available
        return .available
    }
}
```

### Step 1.2: Create Sample Data

**File: `Data/SampleData.swift`**
- Create 3 sections with 10 lessons each (30 total lessons)
- Each lesson should have 6 questions
- Questions should be about flags and continents
- Use appropriate icons for each lesson type
- Structure: Section 1 (Continents), Section 2 (North/South America), Section 3 (Europe/Asia)

### Step 1.3: Create Persistence Layer

**File: `Services/PersistenceService.swift`**
- Implement `UserDefaults` or `Codable` file storage
- Save/load user progress, coins, completed lessons
- Handle app state restoration

## Phase 2: Design System Implementation

### Step 2.1: Create Color Extensions

**File: `Extensions/Color+DesignSystem.swift`**
- Implement all colors from design system
- Add hex color initializer
- Include all background, accent, text, and UI element colors

### Step 2.2: Create Typography Extensions

**File: `Extensions/Font+DesignSystem.swift`**
- Implement all font styles from design system
- Headlines, body text, questions, labels

### Step 2.3: Create Spacing & Layout Extensions

**File: `Extensions/CGFloat+DesignSystem.swift`**
- Implement spacing constants
- Layout constants (padding, gaps)
- Corner radius constants

### Step 2.4: Create Shadow Extensions

**File: `Extensions/View+Shadows.swift`**
- Implement `shadowSubtle()`, `shadowMedium()`, `shadowPronounced()` modifiers

## Phase 3: Reusable Components

### Step 3.1: Create Answer Card Component

**File: `Components/AnswerCard.swift`**
- White rounded card with shadow
- Changes color based on selection state (green for correct, orange for incorrect)
- Supports decorative dots/animations
- Follows design system patterns

### Step 3.2: Create Progress Bar Component

**File: `Components/ProgressBar.swift`**
- Horizontal progress bar
- Orange fill on light grey track
- Accepts progress value (0.0 to 1.0)
- Smooth animation support

### Step 3.3: Create Lesson Pill Component

**File: `Components/LessonPill.swift`**
- Pill-shaped card with three states (completed, available, locked)
- Displays icon, diamonds (if completed), and label
- Different sizes for next lesson vs completed
- Proper color schemes for each state

### Step 3.4: Create Primary Button Component

**File: `Components/PrimaryButton.swift`**
- Orange button with white text
- Full-width with proper padding
- Rounded corners and pronounced shadow
- Reusable action handler

### Step 3.5: Create Section Header Component

**File: `Components/SectionHeader.swift`**
- White pill-shaped card
- Section number and title
- Subtle shadow
- Supports sticky behavior

### Step 3.6: Create Feedback Sheet Component

**File: `Components/FeedbackSheet.swift`**
- Slides up from bottom
- Shows correct/incorrect feedback
- Contains continue button
- Smooth animation

### Step 3.7: Create Diamond Display Component

**File: `Components/DiamondDisplay.swift`**
- Shows 1-3 diamonds
- Gold for filled, grey for empty
- Used in lesson pills and completion screen

## Phase 4: Splash Screen

### Step 4.1: Create Splash Screen View

**File: `Views/SplashView.swift`**
- Display Clever Den logo (fox head + text)
- Warm beige background
- Handle app initialization
- Transition to Course Screen after loading
- Show loading state if needed

### Step 4.2: Update App Entry Point

**File: `CleverDenApp.swift`**
- Set SplashView as initial view
- Handle navigation to Course Screen after splash

## Phase 5: Course Screen (Home)

### Step 5.1: Create Course View Model

**File: `ViewModels/CourseViewModel.swift`**
- Manage sections and lessons data
- Handle lesson status calculation
- Track current section for sticky header
- Handle navigation to lesson

### Step 5.2: Create Top Navigation Bar Component

**File: `Components/TopNavigationBar.swift`**
- Fox logo on left
- Coin counter on right
- Clean, minimal design

### Step 5.3: Create Floating Navigation Bar Component

**File: `Components/FloatingNavBar.swift`**
- White pill-shaped container
- Home icon (active state)
- Profile icon (paw print, inactive state)
- Positioned at bottom
- Medium shadow

### Step 5.4: Implement Sticky Section Header

**File: `Views/CourseView.swift`**
- Use `ScrollViewReader` and `GeometryReader` for sticky behavior
- Section header scrolls normally, then sticks at top
- Updates when scrolling to next section
- Smooth transitions

### Step 5.5: Create Lesson List

**File: `Views/CourseView.swift`**
- Display lessons in vertical list
- Use `LessonPill` component for each lesson
- Handle tap to navigate to lesson
- Show proper states (completed, available, locked)
- Highlight next lesson (larger size)

### Step 5.6: Implement Auto-Scroll to Next Lesson

**File: `Views/CourseView.swift`**
- After lesson completion, scroll to next available lesson
- Use `ScrollViewReader` with `scrollTo()`
- Add brief pause/animation to highlight next lesson
- Smooth scroll animation

### Step 5.7: Wire Up Course Screen

- Connect all components
- Integrate with `UserProgress` for state
- Handle navigation to lesson screen
- Update coin display from `UserProgress`

## Phase 6: Lesson Screen (Quiz)

### Step 6.1: Create Lesson View Model

**File: `ViewModels/LessonViewModel.swift`**
- Manage current question index
- Track selected answers
- Calculate progress (0.0 to 1.0)
- Determine correct/incorrect answers
- Track errors for diamond calculation

### Step 6.2: Create Lesson Top Bar

**File: `Components/LessonTopBar.swift`**
- X button on left (close lesson)
- Progress bar in center
- Status bar on right (system)

### Step 6.3: Create Question Display

**File: `Components/QuestionView.swift`**
- Large, bold question text
- Proper typography from design system
- Clean layout

### Step 6.4: Create Answer Grid

**File: `Views/LessonView.swift`**
- 2x2 grid of answer cards
- Use `AnswerCard` component
- Handle tap to select answer
- Show visual feedback (green/orange)

### Step 6.5: Implement Answer Feedback Flow

**File: `Views/LessonView.swift`**
- When answer selected:
  1. Update card colors immediately
  2. Show feedback sheet with animation
  3. Display correct/incorrect message
  4. Show continue button
- When continue tapped:
  1. Dismiss feedback sheet
  2. Move to next question
  3. Update progress bar
  4. If last question, show completion screen

### Step 6.6: Handle Lesson Exit

**File: `Views/LessonView.swift`**
- X button dismisses lesson
- Confirm if in progress (optional)
- Return to Course Screen
- Save partial progress if needed

### Step 6.7: Wire Up Lesson Screen

- Connect all components
- Integrate with `LessonViewModel`
- Handle question progression
- Track errors for final scoring

## Phase 7: Lesson Complete Screen

### Step 7.1: Create Completion View Model

**File: `ViewModels/LessonCompletionViewModel.swift`**
- Calculate diamonds earned (based on errors)
- Calculate coins earned (25, 50, or 75)
- Update `UserProgress` with results

### Step 7.2: Create Completion Screen Layout

**File: `Views/LessonCompleteView.swift`**
- Top: Diamond display (1-3 diamonds)
- Character image (fox mascot)
- "Great job!" and "Level completed" text
- Reward meter with progress bar
- Continue button at bottom

### Step 7.3: Implement Reward Calculation

**File: `ViewModels/LessonCompletionViewModel.swift`**
- 0 errors = 3 diamonds, 75 coins
- 1-2 errors = 2 diamonds, 50 coins
- 3+ errors = 1 diamond, 25 coins
- Update user progress accordingly

### Step 7.4: Handle Continue Action

**File: `Views/LessonCompleteView.swift`**
- Save progress to persistence
- Update `UserProgress` coins
- Navigate back to Course Screen
- Trigger auto-scroll to next lesson
- Add brief pause/highlight animation

## Phase 8: User Profile Screen (Basic)

### Step 8.1: Create Profile View

**File: `Views/ProfileView.swift`**
- Basic layout for profile screen
- Display user statistics (optional for now)
- Accessible via floating nav bar

### Step 8.2: Implement Navigation

**File: `Views/CourseView.swift`**
- Handle tap on profile icon in floating nav
- Navigate to ProfileView
- Update nav bar active state

## Phase 9: State Management & Persistence

### Step 9.1: Implement UserProgress Persistence

**File: `Services/PersistenceService.swift`**
- Save `UserProgress` on changes
- Load on app launch
- Handle migration if data structure changes

### Step 9.2: Create App State Manager

**File: `Services/AppStateManager.swift`**
- Centralized state management
- Coordinate between views
- Handle app lifecycle events

### Step 9.3: Wire Up State Updates

- Update coins display when coins change
- Update lesson states when lessons complete
- Persist changes automatically

## Phase 10: Animations & Polish

### Step 10.1: Add Answer Card Animations

**File: `Components/AnswerCard.swift`**
- Animate color change on selection
- Add decorative dots/bubbles animation
- Smooth transitions

### Step 10.2: Add Feedback Sheet Animation

**File: `Components/FeedbackSheet.swift`**
- Slide up animation from bottom
- Smooth dismiss animation
- Spring animations for polish

### Step 10.3: Add Progress Bar Animation

**File: `Components/ProgressBar.swift`**
- Animate progress fill smoothly
- Use `withAnimation` for transitions

### Step 10.4: Add Lesson Pill Animations

**File: `Components/LessonPill.swift`**
- Subtle scale animation on tap
- Highlight animation for next lesson
- Smooth state transitions

### Step 10.5: Add Sticky Header Animation

**File: `Views/CourseView.swift`**
- Smooth transition when header becomes sticky
- No jarring jumps or snaps

## Phase 11: Testing & Refinement

### Step 11.1: Test User Flows

- Complete flow: Splash → Course → Lesson → Complete → Course
- Test all lesson states (locked, available, completed)
- Test navigation between screens
- Test auto-scroll functionality

### Step 11.2: Test Edge Cases

- First lesson completion
- Last lesson completion
- All lessons completed
- App restart during lesson
- Network issues (if applicable)

### Step 11.3: Verify Design System Compliance

- All colors match design system
- All typography matches design system
- All spacing matches design system
- All shadows match design system
- All corner radii match design system

### Step 11.4: Performance Optimization

- Optimize list rendering
- Optimize image loading
- Reduce unnecessary re-renders
- Test on different device sizes

### Step 11.5: Accessibility

- Add VoiceOver labels
- Test with accessibility features
- Ensure color contrast
- Test with Dynamic Type

## Phase 12: Data Population

### Step 12.1: Create Complete Question Set

**File: `Data/LessonContent.swift`**
- Create all 30 lessons with 6 questions each (180 total questions)
- Questions about flags and continents
- Appropriate answer options
- Correct answers identified

### Step 12.2: Assign Icons

- Flag icons for flag lessons
- Continent map icons for continent lessons
- Appropriate SF Symbols or custom assets

### Step 12.3: Organize by Sections

- Section 1: Continents (10 lessons)
- Section 2: North and South America (10 lessons)
- Section 3: Europe and Asia (10 lessons)

## Implementation Order Summary

1. **Foundation** (Phase 1): Data models, sample data, persistence
2. **Design System** (Phase 2): Colors, fonts, spacing, shadows
3. **Components** (Phase 3): Reusable UI components
4. **Splash** (Phase 4): Initial screen
5. **Course Screen** (Phase 5): Main navigation and lesson list
6. **Lesson Screen** (Phase 6): Quiz interface
7. **Completion Screen** (Phase 7): Results and rewards
8. **Profile** (Phase 8): User profile (basic)
9. **State Management** (Phase 9): Persistence and app state
10. **Polish** (Phase 10): Animations and transitions
11. **Testing** (Phase 11): Comprehensive testing
12. **Content** (Phase 12): Full question set

## Key Implementation Notes

### Sticky Header Implementation
Use `ScrollViewReader` with `GeometryReader` to detect scroll position. When section header reaches top, change its position to fixed and update opacity/transform.

### Auto-Scroll Implementation
After lesson completion:
1. Calculate next available lesson index
2. Use `ScrollViewReader.scrollTo()` with animation
3. Add delay before highlighting
4. Use scale or pulse animation on next lesson pill

### State Management Pattern
- Use `@Observable` for `UserProgress` (iOS 17+)
- Use `@State` for view-specific state
- Use `@Environment` for shared state
- Persist to `UserDefaults` on changes

### Error Tracking
Track errors in `LessonViewModel`:
- Increment error count on incorrect answer
- Use error count to calculate diamonds at completion
- Reset on new lesson start

### Coin System
- Coins stored in `UserProgress`
- Updated on lesson completion
- Displayed in top navigation bar
- Persisted automatically

## Design System References

Always refer to `.cursor/rules/design-system.mdc` for:
- Exact color values
- Typography specifications
- Spacing constants
- Component patterns
- Shadow definitions

## Best Practices

Follow `.cursor/rules/best-practices.mdc` and `.cursor/rules/views-best-practices.mdc` for:
- Swift best practices
- Optional handling
- Error handling
- SwiftUI component structure
- State management patterns
- Performance optimization
