# Local Testing Procedures

This document outlines the procedures for running tests locally for the iOS Rowing App project.

## Prerequisites

- Xcode 14.3.1 or later
- iOS Simulator 16 or later
- SwiftLint installed via Homebrew: `brew install swiftlint`

## Test Environment Setup

### 1. Project Structure
```
ios-app/
├── d_n_w.xcodeproj
├── d_n_w/                 # Main app target
├── d_n_wTests/           # Unit tests
└── d_n_wUITests/         # UI tests
```

### 2. Test Targets
- **d_n_wTests**: Unit tests for business logic and mock services
- **d_n_wUITests**: End-to-end UI automation tests

## Running Tests Locally

### Option 1: Command Line (Recommended)

```bash
# Navigate to project directory
cd ios-app

# Run all tests
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest'

# Run only unit tests
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing d_n_wTests

# Run only UI tests
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing d_n_wUITests

# Run specific test class
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing d_n_wTests/PM5ServiceTests
```

### Option 2: Xcode IDE

1. Open `ios-app/d_n_w.xcodeproj` in Xcode
2. Select the test target in the scheme selector
3. Choose Product → Test (⌘+U) or press the play button next to tests in the Test Navigator

## Test Coverage

### Current Test Coverage Goals
- **Unit Tests**: Minimum 80% code coverage
- **Critical Components**: 100% coverage for PM5 service layer

### Viewing Coverage Reports
```bash
# Run tests with coverage
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -enableCodeCoverage YES

# Coverage reports are generated in DerivedData
# View in Xcode: Window → Organizer → Reports → Coverage
```

## Mock Testing Framework

### PM5ServiceTests
The project includes comprehensive mock testing for the PM5 Bluetooth service:

- **MockPM5Service**: Simulates PM5 device interactions without hardware
- **17 unit tests** covering:
  - Device scanning and discovery
  - Connection/disconnection flows
  - CSAFE command processing
  - Mock data generation
  - Error handling scenarios

### Key Test Categories
1. **Scanning Tests**: Bluetooth device discovery
2. **Connection Tests**: Device pairing and state management
3. **Sample Rate Tests**: Data sampling configuration
4. **CSAFE Command Tests**: Protocol communication
5. **Mock Mode Tests**: Development mode functionality
6. **Reset Tests**: State cleanup and initialization

## Code Quality Checks

### SwiftLint Integration
```bash
# Run SwiftLint manually
swiftlint lint --path ios-app/d_n_w

# Auto-correct issues where possible
swiftlint lint --path ios-app/d_n_w --fix
```

SwiftLint runs automatically during:
- Local builds in Xcode
- CI/CD pipeline execution
- Pre-commit hooks (if configured)

## Continuous Integration Integration

### GitHub Actions Workflow
Tests automatically run on:
- Pull requests to `main` or `develop` branches
- Push to protected branches

### Local CI Simulation
```bash
# Simulate CI environment locally
export XCODE_VERSION='14.3.1'
export IOS_DESTINATION='platform=iOS Simulator,name=iPhone 16,OS=18.6'

# Run the same commands as CI
xcodebuild clean test -scheme d_n_w -destination "$IOS_DESTINATION" -enableCodeCoverage YES
swiftlint lint --strict
```

## Troubleshooting Common Issues

### Simulator Issues
```bash
# Reset iOS Simulator if tests fail
xcrun simctl shutdown all
xcrun simctl erase all
```

### Build Cache Issues
```bash
# Clean Xcode build cache
xcodebuild clean -scheme d_n_w
rm -rf ~/Library/Developer/Xcode/DerivedData/d_n_w-*
```

### SwiftLint Configuration
- Configuration: `ios-app/.swiftlint.yml`
- Custom rules for PM5 development standards
- Automatic fixes available for most style issues

## Test Data and Fixtures

### Mock PM5 Data
The MockPM5Service generates realistic rowing data:
- **Stroke Rate**: 15-25 SPM (strokes per minute)
- **Power**: 150-250 watts
- **Heart Rate**: 120-160 BPM
- **Pace**: Variable split times

### Device Information
Mock device info includes:
- Serial Number: PM5-MOCK-12345
- Model: PM5-TEST
- Manufacturer: Concept2 Mock
- Erg Machine Type: Static Model D

## Performance Testing

### Test Execution Times
- Unit tests should complete in < 30 seconds
- UI tests may take 2-5 minutes
- Full test suite (including coverage): < 10 minutes

### Memory Usage
Monitor for memory leaks in async operations:
- PM5 connection handling
- Mock data generation timers
- Bluetooth peripheral management

## Best Practices

### Test Naming Convention
Tests follow the AAA pattern with descriptive names:
```swift
func test_methodName_whenCondition_shouldExpectedResult()
```

### Mock Service Usage
- Use MockPM5Service for unit tests
- Avoid direct CBPeripheral instantiation (not supported)
- Reset mock state between tests using `reset()` method

### Async Testing
Handle async operations with proper delays:
```swift
try await Task.sleep(nanoseconds: 150_000_000) // 0.15 seconds
```

## Integration with Development Workflow

### Pre-commit Checks
Recommended pre-commit routine:
1. Run SwiftLint: `swiftlint lint --strict`
2. Run unit tests: `xcodebuild test -scheme d_n_w -only-testing d_n_wTests`
3. Verify no new warnings or errors

### Feature Development
1. Write failing tests first (TDD approach)
2. Implement feature to make tests pass
3. Run full test suite before committing
4. Update test documentation for new features