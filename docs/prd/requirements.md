# Requirements

## Functional
- FR1: The iOS app shall connect to Concept2 PM5 monitors via Bluetooth Low Energy (BLE) and maintain stable connections throughout training sessions
- FR2: The app shall provide machine verification through QR code scanning or machine ID selection with visual confirmation to prevent wrong machine connections
- FR3: The system shall support three user roles (Coach, Athlete, Admin) with appropriate permissions and access controls
- FR4: Athletes shall view real-time performance metrics on their iOS device including watts, stroke rate with flow visualization, split times, distance, and basic power curves
- FR5: The system shall stream all PM5 performance data to cloud storage with less than 1 second latency
- FR6: Coaches shall access a web dashboard showing real-time grid view of all active sessions with athlete names and key metrics
- FR7: The app shall store session data locally when network is unavailable and automatically sync when connection is restored
- FR8: The system shall support team/roster management allowing coaches to create teams, add athletes, and manage organizational structure
- FR9: Users shall view historical session data with detailed performance metrics for individual athletes
- FR10: The system shall capture and store all available PM5 metrics including distance, time, pace, stroke rate, and power output
- FR11: The app shall display connection status and signal strength for each paired PM5 monitor
- FR12: The system shall support concurrent monitoring of 20+ athletes in a single training session
- FR13: Athletes shall be able to start/stop session recording from their device
- FR14: The system shall timestamp all data points for accurate session reconstruction and analysis
- FR15: Coaches shall be able to filter and sort athlete data on the dashboard by various metrics

## Non Functional
- NFR1: The iOS app shall be built using Swift and SwiftUI for native performance and real-time UI updates
- NFR2: Real-time data latency shall be under 1 second 95% of the time between PM5 and athlete device/coach dashboard
- NFR3: The app shall maintain 60fps UI performance for smooth real-time data visualizations
- NFR4: The system shall support 100+ simultaneous BLE connections per location
- NFR5: Session data capture reliability shall exceed 95% (sessions recorded vs. sessions rowed)
- NFR6: The app shall launch in under 3 seconds on iPhone 11 or newer devices
- NFR7: All features shall be developed using Test-Driven Development with minimum 80% code coverage
- NFR8: The system shall maintain 99.9% uptime during standard training hours (5am-9pm local time)
- NFR9: The app shall support iOS 15+ to ensure SwiftUI feature availability
- NFR10: Infrastructure costs shall remain under $500/month for initial deployment
- NFR11: The system shall comply with COPPA requirements for athletes under 13
- NFR12: All sensitive data shall be encrypted in transit and at rest
- NFR13: The web dashboard shall load within 2 seconds on modern browsers
- NFR14: The system shall handle network interruptions gracefully without data loss
- NFR15: Battery usage shall allow for 90-minute training sessions without significant drain
