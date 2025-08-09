# GitHub Project Setup for d_n_w

This document outlines the complete GitHub Issues and Project setup for the d_n_w Rowing Performance Tracking Platform.

## Labels Structure

### Hierarchy Labels
- **epic** (🔴 #B60205) - Large feature that contains multiple stories
- **story** (🟠 #D93F0B) - User story with acceptance criteria 
- **task** (🟡 #FBCA04) - Implementation task for a story
- **subtask** (🟢 #0E8A16) - Small task under another task

### Priority Labels
- **priority-critical** (⚫ #000000) - Blocks release or breaks functionality
- **priority-high** (🔴 #B60205) - Important for MVP
- **priority-medium** (🟠 #D93F0B) - Nice to have for MVP
- **priority-low** (🟢 #0E8A16) - Future enhancement

### Type Labels
- **type-feature** (🔵 #0052CC) - New feature development
- **type-bug** (🔴 #D73A4A) - Bug fix
- **type-enhancement** (🟦 #A2EEEF) - Improvement to existing feature
- **type-docs** (📖 #7057FF) - Documentation
- **type-testing** (🧪 #BFD4F2) - Testing related
- **type-refactor** (♻️ #5319E7) - Code refactoring

### Component Labels
- **comp-ios** (📱 #FF6B35) - iOS app component
- **comp-web** (🌐 #FF9F1C) - Web dashboard component
- **comp-backend** (⚙️ #2E86AB) - Backend services
- **comp-infra** (🏗️ #A23B72) - Infrastructure/DevOps
- **comp-ble** (📡 #F18F01) - BLE/PM5 connectivity
- **comp-sync** (🔄 #C73E1D) - Data synchronization

### Status Labels
- **status-blocked** (🚫 #E4E669) - Cannot proceed due to dependency
- **status-in-review** (👀 #BFDADC) - Under code review
- **status-testing** (🧪 #D4C5F9) - In QA testing
- **status-ready** (✅ #0E8A16) - Ready for development

## Epic Structure (Based on PRD)

### Epic 1: Foundation & Core Infrastructure
**GitHub Issue:** Epic - Foundation & Core Infrastructure
**Labels:** `epic`, `priority-critical`, `comp-backend`, `comp-ios`
**Description:**
```markdown
Establish the technical foundation and core infrastructure needed for the rowing performance tracking platform. This epic delivers the iOS app skeleton with authentication, basic PM5 BLE connectivity, and a simple health check to verify the system is operational.

## Success Criteria
- [ ] iOS app skeleton with SwiftUI
- [ ] Authentication system functional
- [ ] Basic PM5 BLE connection working
- [ ] CI/CD pipeline operational
- [ ] Backend health check endpoint

## Stories
- [ ] #[story-1] Project Setup and iOS App Initialization
- [ ] #[story-2] CI/CD Pipeline and Testing Framework
- [ ] #[story-3] Authentication Service and User Management
- [ ] #[story-4] Core BLE Connection Framework
- [ ] #[story-5] Backend Health Check and Basic API
```

### Epic 2: Real-time Data Capture & Display
**GitHub Issue:** Epic - Real-time Data Capture & Display
**Labels:** `epic`, `priority-critical`, `comp-ios`, `comp-ble`
**Description:**
```markdown
Implement comprehensive BLE data streaming from PM5 monitors to athlete iOS devices with real-time performance visualization.

## Success Criteria
- [ ] Complete PM5 protocol implementation
- [ ] Real-time data streaming <100ms latency
- [ ] Athlete performance dashboard UI
- [ ] Machine verification system
- [ ] Session recording controls

## Stories
- [ ] #[story-6] PM5 Data Protocol Implementation
- [ ] #[story-7] Real-time Data Streaming Architecture  
- [ ] #[story-8] Athlete Performance Dashboard UI
- [ ] #[story-9] Machine Verification System
- [ ] #[story-10] Session Recording Controls
```

### Epic 3: Coach Dashboard & Multi-Athlete Monitoring
**GitHub Issue:** Epic - Coach Dashboard & Multi-Athlete Monitoring
**Labels:** `epic`, `priority-high`, `comp-web`, `comp-backend`
**Description:**
```markdown
Create a comprehensive web-based dashboard enabling coaches to monitor multiple athletes simultaneously during training sessions.

## Success Criteria
- [ ] Web dashboard foundation
- [ ] Real-time athlete grid view
- [ ] Team session management
- [ ] Performance alerts and notifications
- [ ] Detailed athlete drill-down

## Stories
- [ ] #[story-11] Web Dashboard Foundation
- [ ] #[story-12] Real-time Athlete Grid View
- [ ] #[story-13] Team Session Management
- [ ] #[story-14] Performance Alerts and Notifications
- [ ] #[story-15] Detailed Athlete Drill-Down
```

### Epic 4: Data Persistence & Synchronization
**GitHub Issue:** Epic - Data Persistence & Synchronization
**Labels:** `epic`, `priority-high`, `comp-backend`, `comp-sync`
**Description:**
```markdown
Implement reliable data storage in the cloud with offline capabilities and automatic synchronization.

## Success Criteria
- [ ] Cloud storage infrastructure
- [ ] Offline mode implementation
- [ ] Data synchronization service
- [ ] Session data API
- [ ] Data export capabilities

## Stories
- [ ] #[story-16] Cloud Storage Infrastructure
- [ ] #[story-17] Offline Mode Implementation
- [ ] #[story-18] Data Synchronization Service
- [ ] #[story-19] Session Data API
- [ ] #[story-20] Data Export Capabilities
```

### Epic 5: Team Management & Historical Analytics
**GitHub Issue:** Epic - Team Management & Historical Analytics
**Labels:** `epic`, `priority-medium`, `comp-web`, `comp-backend`
**Description:**
```markdown
Enable comprehensive team organization and historical performance analysis.

## Success Criteria
- [ ] Team and roster management
- [ ] Historical session browser
- [ ] Individual session analysis
- [ ] Progress tracking dashboard
- [ ] Basic reporting suite

## Stories
- [ ] #[story-21] Team and Roster Management
- [ ] #[story-22] Historical Session Browser
- [ ] #[story-23] Individual Session Analysis
- [ ] #[story-24] Progress Tracking Dashboard
- [ ] #[story-25] Basic Reporting Suite
```

## Example Story Template

**Title:** As a [role], I want to [goal] so that [benefit]

**Labels:** `story`, `priority-[level]`, `comp-[component]`, `epic-[number]`

**Description Template:**
```markdown
## User Story
As a [role], I want to [goal] so that [benefit].

## Acceptance Criteria
- [ ] Given [context], when [action], then [outcome]
- [ ] Given [context], when [action], then [outcome]
- [ ] Given [context], when [action], then [outcome]

## Technical Notes
- Implementation approach
- Dependencies
- Architecture considerations

## Definition of Done
- [ ] Code implemented with TDD
- [ ] Unit tests passing (80%+ coverage)
- [ ] Integration tests passing
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] QA testing completed

## Related Issues
- Epic: #[epic-number]
- Dependencies: #[issue-numbers]
- Blocks: #[issue-numbers]
```

## GitHub Project Board Setup

### Columns
1. **Backlog** - New issues, not yet prioritized
2. **Ready** - Prioritized and ready for development
3. **In Progress** - Actively being worked on
4. **Review** - Code review in progress
5. **Testing** - QA testing phase
6. **Done** - Completed and merged

### Automation Rules
- Move to "In Progress" when PR is created
- Move to "Review" when PR is marked ready for review
- Move to "Testing" when PR is approved
- Move to "Done" when PR is merged and issue is closed

## Manual Setup Steps

Since GitHub CLI is not available, follow these steps manually:

1. **Create Labels:** Go to Issues → Labels and create all labels listed above
2. **Create Project:** Go to Projects → New Project → Board view
3. **Create Epics:** Create 5 epic issues using the templates above
4. **Create Stories:** For each epic, create the associated story issues
5. **Link Stories to Epics:** Reference epic numbers in story descriptions
6. **Set up Project Board:** Add all issues to the project board
7. **Configure Automation:** Set up project automation rules

## Sprint Planning Process

1. **Sprint Duration:** 2 weeks
2. **Story Points:** Use Fibonacci sequence (1, 2, 3, 5, 8, 13)
3. **Capacity:** Estimate based on team velocity
4. **Sprint Goal:** Clear objective for each sprint
5. **Daily Standups:** Update issue status and project board

## Issue Numbering Convention

- Epic 1-5: Foundation through Analytics
- Stories 1-25: Corresponding to epic breakdown
- Tasks: Number sequentially within each story
- Bugs: Use separate numbering starting from 100

## Labels Usage Guidelines

- Every issue must have: hierarchy label, priority label, component label
- Optional: type label, status label
- Use consistent labeling for filtering and reporting
- Update labels as issues progress through workflow