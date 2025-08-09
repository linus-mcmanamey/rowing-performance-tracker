# Epic 2: Real-time Data Capture & Display

Implement comprehensive BLE data streaming from PM5 monitors to athlete iOS devices with real-time performance visualization. This epic transforms the basic connection into a full-featured performance monitoring experience for athletes, providing immediate feedback on power output, stroke rate, and other key metrics.

## Story 2.1: PM5 Data Protocol Implementation

As a developer,
I want to implement the complete PM5 CSAFE protocol,
so that we can capture all available performance metrics.

### Acceptance Criteria
1: Document all available PM5 data fields and update rates
2: Implement CSAFE protocol commands for data retrieval
3: Parse PM5 data packets into structured data models
4: Handle all standard rowing metrics (distance, time, pace, stroke rate, watts)
5: Implement error handling for malformed packets
6: Create unit tests for protocol implementation
7: Verify data accuracy against PM5 display
8: Handle different PM5 firmware versions gracefully

## Story 2.2: Real-time Data Streaming Architecture

As an athlete,
I want my performance data streamed in real-time to my phone,
so that I can monitor my metrics while rowing.

### Acceptance Criteria
1: Implement Combine framework for reactive data flow
2: Create data pipeline from BLE to UI with <100ms latency
3: Buffer system for smooth data flow despite BLE irregularities
4: Efficient data structures to minimize memory usage
5: Background BLE handling for iOS multitasking
6: Network data streaming to backend implemented
7: Local data caching during network outages
8: Performance profiling confirms 60fps UI updates

## Story 2.3: Athlete Performance Dashboard UI

As an athlete,
I want to see my real-time performance metrics clearly,
so that I can optimize my rowing technique.

### Acceptance Criteria
1: Primary metrics screen shows watts, stroke rate, split time, distance
2: Large, high-contrast fonts readable during exercise
3: Stroke rate visualization shows rhythm/flow with smooth animations
4: Basic power curve graph updates in real-time
5: Swipe navigation between different metric views
6: Landscape and portrait orientations supported
7: Dark mode support for early morning training
8: UI remains responsive during data updates
9: Visual indicators for personal records or target zones

## Story 2.4: Machine Verification System

As an athlete,
I want to verify I'm connected to the correct rowing machine,
so that my data is accurately recorded.

### Acceptance Criteria
1: QR code scanner implemented using iOS camera
2: QR codes link to specific machine IDs
3: Manual machine selection available with visual identifiers
4: Machine name/number displayed prominently when connected
5: Visual confirmation required before starting session
6: Warning if attempting to connect to already-in-use machine
7: Machine assignment persists for quick reconnection
8: Coach can pre-assign athletes to specific machines
9: Clear error messages for scanning issues

## Story 2.5: Session Recording Controls

As an athlete,
I want to control when my rowing session is recorded,
so that only meaningful workouts are captured.

### Acceptance Criteria
1: Start/stop recording button prominently displayed
2: Session automatically pauses when PM5 idle for 30 seconds
3: Visual indicator shows recording status
4: Countdown timer for session start (3-2-1-Go)
5: Quick-save option for interval workouts
6: Ability to discard session if needed
7: Session summary shown before saving
8: Automatic session naming with timestamp
9: Warning before discarding unsaved data
