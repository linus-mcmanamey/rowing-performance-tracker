# Project Brief: Rowing Performance Tracking Platform

## Executive Summary

The Rowing Performance Tracking Platform is an iOS-first mobile application that enables rowing teams and clubs to capture, store, and analyze performance data from Concept2 PM5 rowing machines via Bluetooth Low Energy (BLE) connectivity. The platform provides real-time monitoring capabilities for both coaches and athletes, with rowers able to view live performance metrics including power output (watts) and stroke rate flow on their personal devices. Data is stored in cloud infrastructure for team-wide performance tracking and assessment. The solution addresses the gap between individual rowing machine data and team-level performance management systems.

## Problem Statement

School rowing teams and rowing clubs currently face significant challenges in systematically collecting and analyzing performance data from their training sessions:

- **Data Isolation**: PM5 monitors collect extensive performance metrics, but this data remains trapped on individual machines or personal devices
- **Manual Data Collection**: Coaches resort to clipboards and spreadsheets, leading to errors and time delays
- **Lack of Real-time Visibility**: Coaches cannot monitor multiple athletes simultaneously during training, missing opportunities for immediate corrections
- **Limited Athlete Feedback**: Rowers rely solely on the PM5 monitor, missing detailed real-time analytics like power curves and stroke flow that could improve technique
- **Team Performance Tracking**: No efficient way to track crew combinations, seat positions, and their impact on overall boat performance
- **Historical Analysis**: Difficulty in tracking athlete progress over time and identifying trends
- **Machine Confusion**: In busy boathouses with 10-20+ ergs in close proximity, athletes often connect to wrong machines

The impact is significant: coaches spend hours on administrative tasks instead of coaching, athletes miss valuable performance insights during training, and data-driven improvements are nearly impossible at scale.

## Proposed Solution

A native iOS application built with Swift and SwiftUI that automatically connects to Concept2 PM5 monitors via BLE, ensuring correct machine pairing through QR code scanning or machine ID selection. The app streams performance data in real-time to both the athlete's device and cloud storage (AWS with ClickHouse for analytics), enabling:

- **Athletes**: View real-time performance metrics including power output (watts), stroke rate flow visualization, split times, and technique indicators on their personal iOS device
- **Coaches**: Monitor entire teams simultaneously through a web dashboard with sub-second latency

Key differentiators:
- **Dual Real-time Experience**: Both athletes and coaches get live data during sessions
- **Enhanced Athlete Metrics**: Beyond basic PM5 display - power curves, stroke consistency, fatigue indicators
- **Automated Data Collection**: Zero-friction data capture during every session
- **Machine Verification**: QR code/ID system prevents wrong machine connections
- **Team-Centric Design**: Built specifically for rowing programs, not individual athletes
- **Test-Driven Development**: Ensuring reliability and maintainability from day one

## Target Users

### Primary User Segment: Rowing Coaches
- **Profile**: High school and club rowing coaches managing 20-100+ athletes
- **Current Workflow**: Manual data collection, Excel spreadsheets, ErgData app (individual focus)
- **Pain Points**: 
  - Cannot monitor multiple athletes simultaneously
  - Spend 2-3 hours weekly on data entry
  - Difficult to track boat lineups and their performance
  - Limited visibility into athlete progress trends
- **Goals**: Optimize training time, make data-driven lineup decisions, identify athlete development needs

### Secondary User Segment: Student Athletes/Rowers
- **Profile**: Age 14-22, tech-savvy, competitive mindset
- **Current Workflow**: View PM5 screen, sometimes use personal fitness apps
- **Pain Points**:
  - Limited real-time feedback during workouts
  - Cannot see power curves or stroke consistency
  - No easy way to track personal progress
  - Cannot compare performance with teammates
  - Lose historical data when changing schools/clubs
- **Goals**: Improve technique through better feedback, optimize power output, track progress toward goals

### Tertiary User Segment: Team Administrators
- **Profile**: Athletic directors, team managers, booster club members
- **Current Workflow**: Limited visibility into program metrics
- **Goals**: Demonstrate program value, track equipment usage, support fundraising with data

## Goals & Success Metrics

### Business Objectives
- Launch MVP with 1 pilot school within 3 months
- Achieve 80% daily active usage during rowing season within pilot program
- Expand to 5 additional schools/clubs within 6 months post-MVP
- Maintain 95% data capture reliability (sessions recorded vs. sessions rowed)

### User Success Metrics
- Coaches save 2+ hours per week on data management
- 90% of sessions have correct machine pairing on first attempt
- Real-time data latency under 1 second 95% of the time
- Athletes check real-time metrics during 75%+ of workouts
- Athletes report technique improvements from real-time feedback

### Key Performance Indicators (KPIs)
- **Session Capture Rate**: Percentage of rowing sessions successfully recorded (Target: >95%)
- **Machine Pairing Accuracy**: Correct machine connections on first attempt (Target: >90%)
- **Athlete Engagement**: Percentage using real-time view during workouts (Target: >75%)
- **Coach Engagement**: Weekly active coaches using analytics features (Target: >80%)
- **Data Reliability**: Percentage of complete, error-free session data (Target: >98%)
- **System Uptime**: Platform availability during training hours (Target: 99.9%)

## MVP Scope

### Core Features (Must Have)
- **iOS App with BLE Connectivity:** Native Swift/SwiftUI app that reliably connects to PM5 monitors and maintains stable connection throughout sessions
- **Machine Verification System:** QR code scanner and/or machine ID selection with visual confirmation to ensure correct pairing
- **User Authentication & Roles:** Secure login system with coach, athlete, and admin roles with appropriate permissions
- **Athlete Real-time View:** Live display of watts, stroke rate with flow visualization, split times, distance, and basic power curve using SwiftUI's animation capabilities
- **Real-time Data Streaming:** Capture all PM5 metrics and stream to both athlete's device and cloud with <1s latency
- **Offline Mode & Sync:** Local storage of session data when network unavailable, automatic sync when connection restored
- **Basic Web Dashboard:** Coach view showing active sessions, athlete names, and key metrics in real-time grid layout
- **Session History:** View completed sessions with detailed metrics for individual athletes
- **Team/Roster Management:** Create teams, add athletes, assign coaches, basic organizational structure
- **Test Suite Foundation:** Comprehensive unit tests, integration tests, and BLE connection test harness

### Out of Scope for MVP
- Android app
- iPad-specific coach app  
- Video recording integration
- Training plan creation and management
- Injury tracking or load management features
- Advanced analytics (ML-based insights)
- Export to third-party platforms
- Heart rate monitor integration
- Social features or leaderboards
- Advanced stroke technique analysis

### MVP Success Criteria
The MVP will be considered successful when:
1. Pilot school successfully uses the app for 30 consecutive days
2. 90% of daily sessions are captured without coach intervention
3. Athletes actively use real-time view in 75%+ of sessions
4. Zero data loss incidents during pilot period
5. Coaches report measurable time savings in weekly survey
6. Test coverage exceeds 80% with all critical paths covered

## Post-MVP Vision

### Phase 2 Features
- **Enhanced Athlete Analytics:** Detailed power curves, stroke-by-stroke analysis, fatigue indicators, technique scores
- **Crew Performance Analytics:** Track and analyze performance by boat configurations (pairs, fours, eights) with seat position tracking
- **Regatta Results Integration:** Import and track competition results, correlate with training data
- **Advanced Coach Dashboard:** Multi-screen support, customizable layouts, athlete comparison tools
- **Export Capabilities:** CSV export, API access for third-party tools
- **Machine Learning Insights:** Performance predictions, optimal lineup suggestions using CoreML
- **iPad Coach App:** Optimized tablet experience for real-time monitoring

### Long-term Vision
Within 1-2 years, evolve into the comprehensive rowing program management platform:
- Complete training plan integration with periodization
- Biomechanics analysis through video integration
- Real-time coaching feedback delivered to athlete devices
- National/regional benchmarking and percentiles
- Equipment maintenance tracking and scheduling
- Recruiting tools for college programs
- Parent/spectator apps for live regatta viewing

### Expansion Opportunities
- Professional rowing teams and national team programs
- Indoor rowing competitions and virtual racing
- Integration with on-water GPS/acceleration systems
- White-label solutions for rowing machine manufacturers
- Expansion to other sports with similar training equipment

## Technical Considerations

### Platform Requirements
- **Target Platforms:** iOS 15+ (primary), Web dashboard (Chrome, Safari, Firefox)
- **Device Support:** iPhone 11 and newer for optimal BLE performance and SwiftUI features
- **Performance Requirements:** <1s data latency, 60fps UI for smooth real-time visualizations, <3s app launch time
- **Concurrent Users:** Support 100+ simultaneous BLE connections per location

### Technology Preferences
- **Frontend:** Swift/SwiftUI for iOS (native performance, real-time UI updates), React with TypeScript for web dashboard
- **Backend:** Node.js or Go microservices, GraphQL API, WebSocket for real-time data
- **Database:** ClickHouse for time-series analytics, PostgreSQL for relational data, Redis alternative for real-time cache
- **Infrastructure:** AWS (ECS/Fargate, ALB, CloudFront, S3), Infrastructure as Code with Terraform

### Architecture Considerations
- **Repository Structure:** Monorepo with iOS, web, and backend packages, shared TypeScript types
- **Service Architecture:** Microservices for data ingestion, analytics, user management, real-time streaming
- **Integration Requirements:** Concept2 PM5 BLE protocol, potential future Concept2 Logbook API
- **Security/Compliance:** COPPA compliance for under-13 athletes, FERPA considerations for schools, end-to-end encryption for sensitive data
- **Testing Strategy:** TDD with minimum 80% coverage, automated CI/CD pipeline, BLE testing framework, load testing for concurrent connections
- **Real-time UI:** SwiftUI Combine framework for reactive updates, efficient rendering of live charts and metrics

## Constraints & Assumptions

### Constraints
- **Budget:** Initial development budget of $75-150k, ongoing monthly infrastructure costs <$500 initially
- **Timeline:** MVP delivery in 3 months, Phase 2 features within 6 months
- **Resources:** 2-3 developers, 1 part-time designer, access to rowing equipment for testing
- **Technical:** Limited by Concept2 PM5 BLE protocol capabilities, Apple BLE connection limits, iOS background processing restrictions

### Key Assumptions
- Concept2 PM5 BLE protocol remains stable and documented
- Schools have adequate WiFi coverage in training facilities
- Coaches have access to modern web browsers for dashboard
- Athletes have personal or team-provided iOS devices
- iOS devices can handle real-time UI updates without significant battery drain
- SwiftUI performance is sufficient for smooth real-time data visualization
- ClickHouse provides adequate real-time query performance for coach dashboards

## Risks & Open Questions

### Key Risks
- **BLE Reliability:** Bluetooth connections in environments with 20+ active devices may experience interference
- **Battery Life:** Real-time display and BLE connectivity may drain athlete devices during long sessions
- **Concept2 Protocol Changes:** Undocumented protocol changes could break connectivity
- **Adoption Resistance:** Coaches comfortable with current methods may resist change
- **Infrastructure Costs:** Success could lead to higher-than-expected AWS costs
- **App Store Approval:** BLE and background processing may face review challenges

### Open Questions
- What specific PM5 data fields are available via BLE? Need protocol documentation
- How many simultaneous BLE connections can a single iOS device maintain reliably?
- What's the optimal real-time streaming approach: WebSockets vs Server-Sent Events vs GraphQL subscriptions?
- How do we handle athlete privacy for minors? What parental controls are needed?
- What's the battery impact of continuous BLE + real-time UI updates during 90-minute sessions?
- Can SwiftUI handle smooth 60fps updates of multiple real-time charts?

### Areas Needing Further Research
- Concept2 PM5 BLE protocol documentation and limitations
- SwiftUI performance optimization for real-time data visualization
- Battery optimization strategies for long training sessions
- COPPA/FERPA compliance requirements for educational settings
- Optimal ClickHouse schema design for rowing time-series data
- Load testing with 50+ concurrent BLE connections
- Redis alternatives that avoid licensing issues (KeyDB, Dragonfly, Valkey)

## Appendices

### A. Research Summary
**Market Research Findings:**
- 2,000+ high school rowing programs in the US
- Average program has 40-60 athletes, 10-20 rowing machines
- Current solutions (ErgData, RowPro) focus on individual athletes, not teams
- Coaches spend 3-5 hours weekly on performance data management
- Athletes want more detailed feedback than PM5 monitor provides

**Technical Feasibility:**
- PM5 monitors support BLE connectivity with documented CSAFE protocol
- iOS CoreBluetooth framework suitable for multi-device connections
- SwiftUI capable of smooth real-time data visualization with proper optimization
- ClickHouse proven for similar time-series athletic performance data
- WebSocket infrastructure can achieve <100ms latency

### B. Test-Driven Development Approach

**TDD Implementation Strategy:**
- All features begin with failing tests that define expected behavior
- Minimum 80% code coverage with focus on critical paths
- Test categories:
  - Unit tests for business logic
  - Integration tests for API endpoints
  - UI tests for SwiftUI components and real-time updates
  - End-to-end tests for critical user flows
  - BLE connection simulation framework
  - Performance tests for real-time data flow
  
**Testing Infrastructure:**
- iOS: XCTest with Quick/Nimble for BDD-style tests, SwiftUI preview testing
- Backend: Jest for Node.js or Go testing framework
- Web: Jest + React Testing Library + Cypress for E2E
- CI/CD: GitHub Actions with automated test runs on every PR
- BLE Testing: Mock PM5 device simulator for consistent testing
- Performance Testing: Instruments for iOS profiling, especially for real-time UI

### C. References
- Concept2 PM5 BLE Development Documentation
- CoreBluetooth Framework Documentation
- SwiftUI Performance Best Practices
- Combine Framework for Reactive Programming
- ClickHouse Time-Series Best Practices
- AWS Well-Architected Framework for SaaS
- COPPA Compliance Guidelines

## Next Steps

### Immediate Actions
1. Validate Concept2 PM5 BLE protocol access and documentation availability
2. Conduct detailed technical spike on iOS BLE multi-device connectivity limits
3. Create SwiftUI prototype for real-time data visualization performance testing
4. Set up initial development environment with TDD framework
5. Create detailed wireframes for MVP athlete real-time view and coach dashboard
6. Establish relationship with pilot school and define success metrics
7. Research Redis alternatives and benchmark performance (KeyDB, Dragonfly, Valkey)
8. Define comprehensive test strategy document with coverage targets

### PM Handoff
This Project Brief provides the full context for the Rowing Performance Tracking Platform. Please start in 'PRD Generation Mode', review the brief thoroughly to work with the user to create the PRD section by section as the template indicates, asking for any necessary clarification or suggesting improvements.