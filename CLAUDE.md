# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Critical Project Context

This is the **Rowing Performance Tracker** - an iOS app that connects to PM5 rowing machines via Bluetooth for real-time performance tracking. The project uses **GitHub Issues** for story tracking and follows a structured epic/story workflow.

### Current Development Status
- **Active Branch**: `feature/story-1.2-ci-cd-testing-framework`
- **Epic 1**: Foundation & Core Infrastructure (in progress)
- **Story 1.2**: CI/CD Pipeline and Testing Framework (needs test fixes)

### Critical Dependencies

**ALWAYS use MCP servers for these operations:**
- **Xcode MCP**: All build, test, and device operations (verify with `mcp__XcodeBuildMCP__diagnostic`)
- **GitHub MCP**: All issue, PR, and repository operations

**Repository Info:**
- Owner: `linus-mcmanamey`
- Repo: `rowing-performance-tracker`
- Issues: https://github.com/linus-mcmanamey/rowing-performance-tracker/issues

## Build and Test Commands

### iOS App (via Xcode MCP)
```bash
# Discover project and schemes
mcp__XcodeBuildMCP__discover_projs --workspaceRoot /Users/linusmcmanamey/Development/surfseer/d_n_w
mcp__XcodeBuildMCP__list_schems_proj --projectPath ios-app/d_n_w.xcodeproj

# Build for simulator
mcp__XcodeBuildMCP__build_sim_name_proj --projectPath ios-app/d_n_w.xcodeproj --scheme d_n_w --simulatorName "iPhone 16"

# Run tests
mcp__XcodeBuildMCP__test_sim_name_proj --projectPath ios-app/d_n_w.xcodeproj --scheme d_n_w --simulatorName "iPhone 16"

# Build and run on simulator
mcp__XcodeBuildMCP__build_run_sim_name_proj --projectPath ios-app/d_n_w.xcodeproj --scheme d_n_w --simulatorName "iPhone 16"

# Build for physical device
mcp__XcodeBuildMCP__build_dev_proj --projectPath ios-app/d_n_w.xcodeproj --scheme d_n_w

# List devices
mcp__XcodeBuildMCP__list_devices
mcp__XcodeBuildMCP__list_sims
```

### Code Quality
```bash
# SwiftLint (run from ios-app directory)
cd ios-app && swiftlint lint --strict

# Test coverage check (after running tests)
xcrun xccov view DerivedData/Logs/Test/*.xcresult --report --json
```

### Git Workflow
```bash
# Create feature branch for a story
git checkout -b feature/story-X.Y-description

# After implementation, create PR via GitHub MCP
mcp__github__create_pull_request --owner linus-mcmanamey --repo rowing-performance-tracker --title "Story X.Y: Title" --head feature/story-X.Y --base main
```

## Project Architecture

### Monorepo Structure
```
rowing-performance-tracker/
├── ios-app/                 # iOS application
│   ├── d_n_w/              # Main app source
│   │   ├── PM5/            # PM5 BLE implementation (CRITICAL)
│   │   │   ├── PM5Controller.swift      # Main BLE controller
│   │   │   ├── CSAFEProtocol.swift     # CSAFE command protocol
│   │   │   ├── PM5DataParser.swift     # Data parsing
│   │   │   └── PM5DataModels.swift     # Data models
│   │   ├── Views/          # SwiftUI views
│   │   └── Models/         # Data models
│   ├── d_n_wTests/         # Unit tests (must maintain 80% coverage)
│   └── d_n_wUITests/       # UI tests
├── docs/                    # Architecture and story documentation
│   ├── stories/            # User story specifications
│   └── PM5_BLE_Implementation.md  # PM5 protocol documentation
├── .github/workflows/       # CI/CD pipelines
└── backend-services/        # Backend (Phase 2, not yet implemented)
```

### PM5 Bluetooth Architecture

The PM5 BLE implementation is the core of this app. Key components:

1. **PM5Controller**: Manages BLE connections, implements `CBCentralManagerDelegate` and `CBPeripheralDelegate`
2. **CSAFEProtocol**: Handles CSAFE command/response protocol for PM5 control
3. **PM5DataParser**: Parses binary data from PM5 characteristics (little-endian format)
4. **Data Flow**: PM5 → BLE → Parser → Models → SwiftUI Views

**Critical BLE Services:**
- Device Info (0x0010): Hardware/firmware information
- Control (0x0020): CSAFE command/response
- Rowing (0x0030): Real-time rowing data

### Testing Strategy

**Requirements:**
- 80% code coverage minimum (enforced in CI)
- All PM5 components must have unit tests
- Mock BLE services for testing without hardware
- SwiftLint must pass with no violations

**Test Files Pattern:**
- `PM5ControllerTests.swift` - BLE connection tests
- `PM5DataParserTests.swift` - Data parsing tests
- `CSAFEProtocolTests.swift` - Protocol tests

## Development Workflow

### Before Starting Any Story

1. **Check GitHub Issue Comments**: Always read issue comments for implementation instructions
2. **Read Story Document**: Check `docs/stories/story-X.Y.md` for specifications
3. **Verify MCP Servers**: Run `mcp__XcodeBuildMCP__diagnostic` to ensure setup

### Story Implementation Process

1. **Create feature branch**: `feature/story-X.Y-description`
2. **Implement acceptance criteria** from GitHub issue
3. **Write/update tests** to maintain 80% coverage
4. **Run SwiftLint** and fix all violations
5. **Test on simulator** using MCP commands
6. **Create PR** via GitHub MCP with proper description
7. **Address QA feedback** from issue comments

### Known Issues (Story 1.2)

Current test failures to fix:
- PM5DataParserTests: UUID creation issues
- PM5ServiceTests: Initialization failures
- Code coverage below 80% threshold
- SwiftLint violations need resolution

## GitHub Operations

### Issue Management
```bash
# List open stories
mcp__github__search_issues --q "is:open repo:linus-mcmanamey/rowing-performance-tracker label:user-story"

# Get specific issue with comments
mcp__github__get_issue --owner linus-mcmanamey --repo rowing-performance-tracker --issue_number <number>

# Add comment to issue
mcp__github__add_issue_comment --owner linus-mcmanamey --repo rowing-performance-tracker --issue_number <number> --body "Comment"
```

### Pull Request Operations
```bash
# Create PR for story
mcp__github__create_pull_request --owner linus-mcmanamey --repo rowing-performance-tracker --title "Story X.Y: Title" --head feature/story-X.Y --base main --body "Implements acceptance criteria for Story X.Y"

# List PRs
mcp__github__list_pull_requests --owner linus-mcmanamey --repo rowing-performance-tracker --state open
```

## Testing Without PM5 Hardware

The app includes mock mode for development without a physical PM5:
1. Use `MockPM5Service` in tests
2. Enable mock mode in `PM5Controller` for UI testing
3. Simulator testing uses mock BLE responses

## CI/CD Pipeline

GitHub Actions workflow (`ios-ci.yml`) runs on every PR:
1. SwiftLint validation
2. Build for iOS Simulator
3. Run unit tests
4. Check 80% coverage threshold
5. Generate test reports

Pipeline will fail if:
- SwiftLint has violations
- Tests fail
- Coverage < 80%
- Build errors occur