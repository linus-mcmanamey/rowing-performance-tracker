# Epic 5: Team Management & Historical Analytics

Enable comprehensive team organization and historical performance analysis through SwiftData + CloudKit shared databases. This epic completes the MVP by providing coaches with native iOS team management tools and both coaches and athletes with access to historical performance data for tracking progress over time.

## Story 5.1: Team and Roster Management

As a coach,
I want to manage my team roster and organization,
so that athletes are properly grouped and tracked.

### Acceptance Criteria
1: Create/edit/delete teams using SwiftData Team models
2: Add athletes via CloudKit record sharing invitations
3: Assign coaches via CloudKit shared database participants
4: Team hierarchy using SwiftData relationships
5: Athlete profiles stored in SwiftData with CloudKit sync
6: Bulk import from CSV into SwiftData models
7: Active/inactive status via SwiftData boolean properties
8: Transfer athletes via CloudKit record sharing updates
9: Team access via CloudKit record sharing links
10: View team member list with CloudKit participant roles

## Story 5.2: Historical Session Browser

As a user,
I want to browse and search past rowing sessions,
so that I can review performance history.

### Acceptance Criteria
1: SwiftUI List with SwiftData @Query for sessions
2: Filter by date range using @Query predicates
3: Filter by athlete using CloudKit permissions (coaches see shared data)
4: Search by session notes using SwiftData text search
5: Sort by various metrics using @Query sort descriptors
6: LazyVStack for large result sets with SwiftData pagination
7: Quick stats summary using SwiftData aggregate queries
8: Favorite sessions using SwiftData boolean property
9: Session comparison using SwiftData multi-selection

## Story 5.3: Individual Session Analysis

As a user,
I want to analyze individual session details,
so that I can understand performance patterns.

### Acceptance Criteria
1: Complete session metrics displayed
2: Interactive graphs for power, stroke rate over time
3: Split analysis with pace per segment
4: Stroke-by-stroke data table
5: Statistical summary (avg, max, min)
6: Power curve visualization
7: Fatigue analysis indicators
8: Export session as PDF report
9: Share session via link

## Story 5.4: Progress Tracking Dashboard

As an athlete,
I want to see my progress over time,
so that I can measure improvement and stay motivated.

### Acceptance Criteria
1: Personal records display for key metrics
2: Progress graphs over weeks/months
3: Training volume statistics
4: Performance trend indicators
5: Goal setting and tracking
6: Comparative analysis with team averages
7: Milestone achievements/badges
8: Customizable date ranges
9: Mobile-responsive design

## Story 5.5: Basic Reporting Suite

As a coach,
I want standardized reports on team performance,
so that I can track progress and communicate with stakeholders.

### Acceptance Criteria
1: Weekly training summary report
2: Individual athlete progress reports
3: Team performance comparison
4: Attendance tracking
5: PDF generation for all reports
6: Email scheduling for regular reports
7: Custom date range selection
8: Include charts and visualizations
9: Printable formatting
