# About Clever Den

## Overview

Clever Den is an iOS educational game designed to help users learn about flags and continents through an engaging, gamified learning experience. The app features a warm, modern design with a fox mascot character that guides users through their learning journey.

## App Purpose

The primary goal of Clever Den is to make learning geography (specifically flags and continents) fun and interactive through:
- **Quiz-based learning**: Multiple-choice questions that test knowledge
- **Progressive difficulty**: Lessons organized into sections that build upon each other
- **Reward system**: Coins and diamonds earned based on performance
- **Visual feedback**: Immediate feedback on correct/incorrect answers

## Core Features

### 1. Splash Screen
- Displays while the app is loading
- Features the Clever Den logo with a stylized fox head
- Warm beige background (`Color.backgroundPrimary`)
- Logo consists of orange/red fox head with blue eyes and "Clever Den" text

### 2. Course Screen (Home)

The main screen where users browse and select lessons.

#### Navigation
- **Top Bar**:
  - Left: Small fox head logo
  - Right: Coin counter showing user's current balance (e.g., "3" with gold coin icon)
- **Floating Navigation Bar** (bottom):
  - Home icon (house.fill) - active state for course screen
  - Profile icon (pawprint.fill) - inactive state, leads to user profile

#### Section Structure
- **Sticky Section Headers**: 
  - White pill-shaped cards with rounded corners
  - Display section number (e.g., "Section 1") in smaller grey text
  - Display section title (e.g., "Continents") in larger, bold dark text
  - Scrolls with content initially, then becomes sticky at the top when scrolling to next section
  - Uses subtle shadow for elevation

#### Lesson Pills
Lessons are displayed as large, vertically-oriented pill-shaped cards with three distinct states:

1. **Completed Lessons**:
   - Orange/red background (`Color.accentOrange`)
   - Icon at the top (varies by lesson type: flag icon, continent map, etc.)
   - Three yellow/gold diamond icons below the main icon (indicating 3 stars earned)
   - Lesson label text below diamonds (e.g., "Europe flags p. 1")
   - Subtle shadow
   - Standard size

2. **Next Lesson** (Available but not completed):
   - Orange/red background (`Color.accentOrange`)
   - Icon at the top
   - **No diamonds displayed** (lesson not yet completed)
   - Lesson label text
   - Subtle shadow
   - **Larger size** than completed lessons to draw attention

3. **Locked Lessons** (Not yet available):
   - Grey background (`Color.inactiveGrey`)
   - Icon in darker grey (`Color.inactiveIcon`)
   - No diamonds
   - Lesson label in light grey (`Color.textInactive`)
   - Subtle shadow
   - Standard size

#### Lesson Icons
Icons vary based on lesson type:
- Flag icons for flag-related lessons
- Continent map icons for continent-related lessons
- Other relevant icons depending on lesson content

### 3. Lesson Screen (Quiz)

Interactive quiz interface where users answer questions.

#### Layout
- **Top Bar**:
  - Left: Close button (X icon) to exit lesson
  - Center: Progress bar showing completion percentage
    - Orange fill (`Color.accentOrange`) on light grey track
    - Progresses as questions are answered
  - Right: iOS status bar

- **Question Section**:
  - Large, bold question text at the top
  - Uses `.question` font (28pt, bold)
  - Dark text color (`Color.textPrimary`)

- **Answer Cards**:
  - Four white rounded rectangular cards in a 2x2 grid
  - Each card contains a single answer option
  - Uses `.bodyLarge` font
  - Subtle shadow for elevation
  - Cards are tappable

#### Question Flow
- Each lesson contains **6 questions**
- Questions are presented one at a time
- User selects an answer by tapping a card

#### Answer Feedback

When a user selects an answer:

1. **Visual Card Feedback**:
   - **Correct Answer**: Card turns green (`Color.accentGreen`) with white text
     - Small green dots/bubbles animate around edges
   - **Incorrect Answer**: Card turns orange/red (`Color.accentOrange`) with white text
     - Small red X marks or bubbles animate around edges
   - Other cards remain white

2. **Feedback Sheet**:
   - Slides up from the bottom with rounded top corners
   - White background with shadow
   - Contains:
     - **Top side**: 
       - Green checkmark icon + "Correct" text (for correct answers)
       - Red X icon + "Incorrect" text (for incorrect answers)
     - **Bottom side**:
       - Orange "Continue" button
       - Full-width button with white bold text
       - Rounded corners, pronounced shadow
   - User taps "Continue" to proceed to next question

#### Progress Tracking
- Progress bar fills incrementally with each answered question
- Progress = (questions answered) / 6

### 4. Lesson Complete Screen

Displayed after completing all 6 questions in a lesson.

#### Layout
- **Top Section**:
  - **Diamonds**: Three diamond icons displayed horizontally
    - Filled diamonds: Gold (`Color.accentGold`) - earned
    - Empty diamonds: Grey (`Color.inactiveStar`) - not earned
    - Number of filled diamonds (1-3) depends on performance:
      - 3 diamonds: Perfect score (0 errors)
      - 2 diamonds: 1-2 errors
      - 1 diamond: 3+ errors
  - **Character Image**: Fox mascot character with happy expression
    - Positioned below diamonds

- **Center Content**:
  - "Great job!" in large, bold text (`.headlineMedium`)
  - "Level completed" in medium text below

- **Reward Meter**:
  - White rounded card with subtle shadow
  - Contains:
    - Left: "Lever reward" label in medium grey
    - Center: Orange progress bar showing reward level
    - Right: Reward amount ("+25", "+50", or "+75") with gold coin icon
  - Reward amounts:
    - **75 coins**: Perfect score (3 diamonds)
    - **50 coins**: Good performance (2 diamonds)
    - **25 coins**: Completed lesson (1 diamond)

- **Continue Button**:
  - Full-width orange button at bottom
  - White bold text
  - Rounded corners, pronounced shadow
  - Same style as feedback sheet button

#### Post-Completion Behavior
When user taps "Continue":
1. Coins are added to user's wallet
2. Returns to Course Screen (home)
3. **Auto-scrolls** to the next active lesson
4. Next lesson **pauses briefly** with a subtle animation to notify user to click it

### 5. User Profile Screen

Accessible via the paw print icon in the floating navigation bar.
- Displays user statistics and progress
- (Details to be implemented based on design requirements)

## Course Structure

### Overall Organization
- **Total Lessons**: 30 lessons
- **Sections**: 3 sections
- **Lessons per Section**: 10 lessons each
- **Questions per Lesson**: 6 questions

### Section Breakdown

1. **Section 1: Continents**
   - 10 lessons covering basic continent knowledge
   - Lessons may include: continent identification, continent features, etc.

2. **Section 2: North and South America**
   - 10 lessons focused on American flags and geography
   - Covers countries in North and South America

3. **Section 3: Europe and Asia**
   - 10 lessons covering European and Asian flags
   - Covers countries in Europe and Asia

### Lesson Progression
- Lessons must be completed in order within each section
- Completing a lesson unlocks the next lesson in the section
- Users cannot access locked lessons until prerequisites are met
- Progress is saved automatically

## Design System

The app follows a comprehensive design system documented in `.cursor/rules/design-system.mdc`. Key elements include:

- **Color Palette**: Warm beige backgrounds, orange/red accents, green for success, gold for rewards
- **Typography**: Clear hierarchy with question, headline, body, and label fonts
- **Spacing**: Consistent spacing scale from 8pt to 40pt
- **Components**: Reusable patterns for cards, buttons, progress bars, etc.
- **Shadows**: Three levels of elevation (subtle, medium, pronounced)

## Technical Considerations

### State Management
- Use SwiftUI's state management (`@State`, `@Observable`, `@Environment`)
- Persist user progress, coins, and lesson completion status
- Consider using `UserDefaults` or Core Data for persistence

### Performance
- Optimize image loading for lesson icons and character images
- Efficient list rendering for course screen
- Smooth animations for feedback and transitions

### Accessibility
- Support VoiceOver for all interactive elements
- Ensure sufficient color contrast
- Provide accessibility labels and hints

## User Flow Summary

1. **Launch** → Splash Screen
2. **Splash** → Course Screen (Home)
3. **Course Screen** → Tap lesson pill → Lesson Screen
4. **Lesson Screen** → Answer 6 questions → Lesson Complete Screen
5. **Lesson Complete** → Tap Continue → Course Screen (auto-scrolls to next lesson)
6. **Course Screen** → Tap next lesson → Repeat

## Key Interactions

- **Lesson Selection**: Tap any available lesson pill to start
- **Answer Selection**: Tap an answer card to select it
- **Continue**: Tap "Continue" button after feedback or completion
- **Exit Lesson**: Tap X button in top-left of lesson screen
- **Navigation**: Tap icons in floating nav bar to switch between Course and Profile screens
- **Scrolling**: Scroll vertically through lessons; section headers become sticky

## Future Enhancements (Potential)

- Additional sections and lessons
- More question types (matching, fill-in-the-blank)
- Social features (leaderboards, sharing)
- Offline mode
- Sound effects and background music
- Achievement system beyond diamonds
- Daily challenges
