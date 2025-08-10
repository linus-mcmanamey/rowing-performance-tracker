# Epic 3: Coach Dashboard & Multi-Athlete Monitoring

Create comprehensive iOS coach tools enabling coaches to monitor multiple athletes simultaneously during training sessions. This epic delivers the core value proposition for coaches - real-time visibility into entire team performance with actionable insights through native iOS apps with CloudKit data sharing.

## Story 3.1: Coach iOS App Foundation

As a developer,
I want to create the coach-specific iOS app features,
so that coaches can monitor athletes through their iOS devices.

### Acceptance Criteria
1: Coach user role detection via CloudKit user data
2: Team management interface for coach views
3: CloudKit shared databases for coach-athlete data sharing
4: Real-time data subscriptions via CloudKit push notifications
5: Coach-specific navigation with athlete monitoring focus
6: Landscape orientation optimized for monitoring multiple athletes
7: Background app refresh for continuous monitoring
8: Handoff support between coach's Apple devices
9: Split-screen multitasking support on iPad

## Story 3.2: Real-time Athlete Grid View

As a coach,
I want to see all active athletes in a grid layout,
so that I can monitor the entire team at once.

### Acceptance Criteria
1: SwiftUI LazyVGrid displays all active team athletes
2: Each cell shows athlete name, current watts, stroke rate, split
3: Real-time updates via CloudKit subscriptions <1 second latency
4: Visual indicators for connection status using SF Symbols
5: Cells color-coded by performance zones using SwiftUI
6: Grid auto-sizes based on number of athletes
7: Smooth SwiftUI animations for data updates
8: Tap athlete cell for detailed view modal
9: Empty cells for athletes not yet connected
10: Sort options by name, performance metrics with @Query predicates

## Story 3.3: Team Session Management

As a coach,
I want to create and manage training sessions,
so that athletes are organized and data is properly categorized.

### Acceptance Criteria
1: Create new training session with name and type
2: Select roster of athletes for session
3: Assign athletes to specific machines (optional)
4: Start/stop session for entire team
5: Session timer displayed prominently
6: Pause/resume capability for breaks
7: Quick notes field for session observations
8: Session saved automatically to history
9: Ability to run multiple concurrent sessions

## Story 3.4: Performance Alerts and Notifications

As a coach,
I want to receive alerts for notable performance events,
so that I can provide timely feedback.

### Acceptance Criteria
1: Configurable alerts for performance thresholds
2: Visual highlight when athlete exceeds/drops below targets
3: Connection lost alerts for technical issues
4: Fatigue indicators based on power/rate drops
5: Personal record notifications
6: Alert history sidebar
7: Audio notifications optional
8: Customizable per athlete or team-wide
9: Snooze/dismiss functionality

## Story 3.5: Detailed Athlete Drill-Down

As a coach,
I want to see detailed metrics for individual athletes,
so that I can provide specific technical feedback.

### Acceptance Criteria
1: Click athlete opens detailed view overlay
2: Full PM5 metrics displayed
3: Real-time graphs for power and stroke rate
4: Stroke-by-stroke data table
5: Compare to session average
6: Compare to personal best
7: Notes field for coach observations
8: Quick return to grid view
9: Multiple detail views can be opened
