# Epic 3: Coach Dashboard & Multi-Athlete Monitoring

Create a comprehensive web-based dashboard enabling coaches to monitor multiple athletes simultaneously during training sessions. This epic delivers the core value proposition for coaches - real-time visibility into entire team performance with actionable insights.

## Story 3.1: Web Dashboard Foundation

As a developer,
I want to create the web dashboard infrastructure,
so that coaches can access real-time data through their browsers.

### Acceptance Criteria
1: React application created with TypeScript
2: Responsive design works on laptop and desktop screens
3: WebSocket connection established to real-time service
4: Authentication integrated with coach login
5: Basic layout with header, navigation, and main content area
6: Dashboard accessible at app.rowingtracker.com
7: Loading states for data fetching
8: Error boundaries for component failures
9: Cross-browser testing (Chrome, Safari, Firefox)

## Story 3.2: Real-time Athlete Grid View

As a coach,
I want to see all active athletes in a grid layout,
so that I can monitor the entire team at once.

### Acceptance Criteria
1: Grid displays all currently active athletes
2: Each cell shows athlete name, current watts, stroke rate, split
3: Real-time updates with <1 second latency
4: Visual indicators for connection status
5: Cells color-coded by performance zones (optional)
6: Grid auto-sizes based on number of athletes
7: Smooth animations for data updates
8: Click athlete cell for detailed view
9: Empty cells for athletes not yet connected
10: Sort options by name, performance metrics

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
