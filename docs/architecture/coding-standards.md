# Coding Standards - iOS Development

## Overview

This document establishes mandatory coding standards for the rowing performance tracking platform's iOS development team. These standards ensure consistency, maintainability, and quality across all Swift/SwiftUI code, with a focus on test-driven development practices.

**Compliance Level:** MANDATORY for all developers and AI agents

## Technology Stack & Versions

| Technology | Version | Purpose |
|------------|---------|---------|
| Swift | 5.5+ | Primary development language |
| SwiftUI | iOS 15+ | Modern declarative UI framework |
| UIKit | iOS 15+ | Legacy UI support and advanced components |
| Combine | iOS 15+ | Reactive programming and state management |
| XCTest | Latest | Unit and integration testing |
| Core Bluetooth | iOS 15+ | PM5 device communication |

## Test-Driven Development (TDD)

### TDD Cycle (RED-GREEN-REFACTOR)

**MANDATORY APPROACH:** All new features must follow strict TDD:

1. **RED:** Write a failing test that describes the desired behavior
2. **GREEN:** Write minimal code to make the test pass
3. **REFACTOR:** Improve code while keeping tests green

### Test Organization

```
ProjectName/
├── Sources/
│   └── ProjectName/
│       ├── Models/
│       ├── Views/
│       ├── ViewModels/
│       └── Services/
└── Tests/
    ├── ProjectNameTests/          # Unit tests
    │   ├── ModelTests/
    │   ├── ViewModelTests/
    │   └── ServiceTests/
    └── ProjectNameUITests/        # UI integration tests
```

### Test Naming Convention

```swift
// Format: test_methodName_condition_expectedResult
func test_connectToPM5_whenBluetoothDisabled_shouldReturnError() { }
func test_validateWorkoutData_whenValidInput_shouldReturnSuccess() { }
func test_parseCSAFEResponse_whenInvalidData_shouldThrowParsingError() { }
```

### Test Structure (AAA Pattern)

```swift
func test_calculatePace_whenValidDistance_shouldReturnCorrectPace() {
    // ARRANGE
    let calculator = PaceCalculator()
    let distance = 2000.0 // meters
    let time = 420.0 // seconds (7:00)
    
    // ACT
    let pace = calculator.calculatePace(distance: distance, time: time)
    
    // ASSERT
    XCTAssertEqual(pace.totalSeconds, 126, "Pace should be 2:06 per 500m")
}
```

### Coverage Requirements

- **Unit Tests:** 90% code coverage minimum
- **Integration Tests:** All external service interactions
- **UI Tests:** Critical user journeys (connection, workout start/stop)

## Swift Language Standards

### Code Style & Formatting

**Linting:** Use SwiftLint with the following configuration:

```yaml
# .swiftlint.yml
opt_in_rules:
  - empty_count
  - trailing_newline
  - colon
  - comma

disabled_rules:
  - trailing_whitespace

line_length:
  warning: 120
  error: 140

identifier_name:
  min_length: 3
  max_length: 40
```

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `PM5Controller`, `WorkoutSession` |
| Structs | PascalCase | `WorkoutData`, `PM5Metrics` |
| Protocols | PascalCase + "able"/"Protocol" | `Connectable`, `PM5Protocol` |
| Variables | camelCase | `connectionState`, `currentWorkout` |
| Constants | camelCase | `maxRetryAttempts`, `defaultTimeout` |
| Enums | PascalCase | `ConnectionState`, `WorkoutType` |
| Enum Cases | camelCase | `.connected`, `.disconnected` |
| Methods | camelCase | `connectToDevice()`, `startWorkout()` |

### Critical Language Rules

**1. Force Unwrapping Prohibition**
```swift
// ❌ NEVER DO THIS
let deviceName = peripheral.name!

// ✅ ALWAYS DO THIS
guard let deviceName = peripheral.name else {
    logger.warning("Peripheral has no name")
    return
}
```

**2. Error Handling Patterns**
```swift
// ✅ Result Type for Operations
func connectToDevice() -> Result<Void, PM5Error> {
    // Implementation
}

// ✅ Throwing Functions for Critical Operations  
func parseWorkoutData(_ data: Data) throws -> WorkoutMetrics {
    // Implementation
}
```

**3. Async/Await Usage**
```swift
// ✅ Use async/await for modern Swift concurrency
@MainActor
class PM5Controller: ObservableObject {
    func startWorkout() async throws {
        let session = try await createWorkoutSession()
        await updateUI(with: session)
    }
}
```

**4. Memory Management**
```swift
// ✅ Use weak references for delegates and closures
class PM5Controller {
    weak var delegate: PM5ControllerDelegate?
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: .bluetoothStateChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleBluetoothStateChange()
        }
    }
}
```

## SwiftUI Standards

### Architecture Pattern: MVVM

**MANDATORY:** All SwiftUI views must follow strict MVVM separation:

```swift
// ✅ View Layer - UI Only
struct WorkoutView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.currentPace)
            Button("Start Workout") {
                viewModel.startWorkout()
            }
        }
        .onAppear {
            viewModel.initialize()
        }
    }
}

// ✅ ViewModel Layer - Business Logic
@MainActor
class WorkoutViewModel: ObservableObject {
    @Published var currentPace: String = "0:00"
    @Published var isWorkoutActive: Bool = false
    
    private let pm5Service: PM5Service
    
    init(pm5Service: PM5Service = .shared) {
        self.pm5Service = pm5Service
    }
    
    func startWorkout() {
        Task {
            do {
                try await pm5Service.startWorkout()
                isWorkoutActive = true
            } catch {
                // Handle error
            }
        }
    }
}
```

### State Management Rules

**1. Published Properties**
```swift
// ✅ Use @Published for UI state
@Published var connectionState: ConnectionState = .disconnected
@Published var workoutMetrics: WorkoutMetrics?
@Published var errorMessage: String?
```

**2. State Object vs Observed Object**
```swift
// ✅ Use @StateObject for ownership
struct MainView: View {
    @StateObject private var pm5Controller = PM5Controller()
}

// ✅ Use @ObservedObject for dependency injection
struct WorkoutView: View {
    @ObservedObject var pm5Controller: PM5Controller
}
```

**3. Environment Objects**
```swift
// ✅ Use for shared app-wide state
@main
struct RowingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PM5Controller())
        }
    }
}
```

### UI Component Standards

**1. View Decomposition**
```swift
// ✅ Break down complex views
struct WorkoutView: View {
    var body: some View {
        VStack {
            WorkoutHeaderView()
            WorkoutMetricsView()
            WorkoutControlsView()
        }
    }
}

// ✅ Small, focused components
struct WorkoutHeaderView: View {
    var body: some View {
        HStack {
            Text("Current Workout")
                .font(.headline)
            Spacer()
            ConnectionStatusView()
        }
        .padding()
    }
}
```

**2. Accessibility Requirements**
```swift
// ✅ MANDATORY accessibility labels
Button("Start Workout") {
    startWorkout()
}
.accessibilityLabel("Start rowing workout")
.accessibilityHint("Begins a new workout session")

Text(currentPace)
    .accessibilityLabel("Current pace: \(currentPace) per 500 meters")
```

## Core Bluetooth Standards

### Connection Management

```swift
// ✅ Proper delegate isolation for Swift 6
extension PM5Controller: CBCentralManagerDelegate {
    nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Task { @MainActor in
            switch central.state {
            case .poweredOn:
                self.connectionState = .ready
            case .poweredOff:
                self.error = .bluetoothNotAvailable
            default:
                break
            }
        }
    }
}
```

### Error Handling for Bluetooth

```swift
// ✅ Comprehensive error types
enum PM5Error: LocalizedError {
    case bluetoothNotAvailable
    case deviceNotFound
    case connectionFailed
    case serviceDiscoveryFailed
    case dataParsingFailed
    
    var errorDescription: String? {
        switch self {
        case .bluetoothNotAvailable:
            return "Bluetooth is not available. Please enable Bluetooth and try again."
        case .deviceNotFound:
            return "PM5 device not found. Ensure your device is nearby and powered on."
        case .connectionFailed:
            return "Failed to connect to PM5 device."
        case .serviceDiscoveryFailed:
            return "Failed to discover PM5 services."
        case .dataParsingFailed:
            return "Failed to parse workout data from PM5 device."
        }
    }
}
```

## Testing Standards

### Unit Testing Requirements

**1. ViewModel Testing**
```swift
class WorkoutViewModelTests: XCTestCase {
    private var viewModel: WorkoutViewModel!
    private var mockPM5Service: MockPM5Service!
    
    override func setUp() {
        super.setUp()
        mockPM5Service = MockPM5Service()
        viewModel = WorkoutViewModel(pm5Service: mockPM5Service)
    }
    
    func test_startWorkout_whenServiceSucceeds_shouldUpdateState() async {
        // Given
        mockPM5Service.startWorkoutResult = .success(())
        
        // When
        await viewModel.startWorkout()
        
        // Then
        XCTAssertTrue(viewModel.isWorkoutActive)
        XCTAssertEqual(mockPM5Service.startWorkoutCallCount, 1)
    }
}
```

**2. Service Testing with Mock Protocols**
```swift
protocol PM5ServiceProtocol {
    func startWorkout() async throws
    func stopWorkout() async throws
    func getCurrentMetrics() -> WorkoutMetrics?
}

class MockPM5Service: PM5ServiceProtocol {
    var startWorkoutResult: Result<Void, PM5Error>?
    var startWorkoutCallCount = 0
    
    func startWorkout() async throws {
        startWorkoutCallCount += 1
        switch startWorkoutResult {
        case .success():
            return
        case .failure(let error):
            throw error
        case .none:
            throw PM5Error.connectionFailed
        }
    }
}
```

### UI Testing Standards

```swift
class WorkoutUITests: XCTestCase {
    func test_startWorkoutFlow_whenBluetoothConnected_shouldShowMetrics() {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to workout screen
        app.buttons["Start New Workout"].tap()
        
        // Verify workout started
        XCTAssertTrue(app.staticTexts["Workout Active"].exists)
        XCTAssertTrue(app.staticTexts.matching(identifier: "current-pace").element.exists)
    }
}
```

## File Organization

### Project Structure
```
RowingApp/
├── Sources/
│   ├── Models/
│   │   ├── WorkoutModels.swift
│   │   ├── PM5Models.swift
│   │   └── CSAFEModels.swift
│   ├── Views/
│   │   ├── WorkoutViews/
│   │   ├── SettingsViews/
│   │   └── SharedComponents/
│   ├── ViewModels/
│   │   ├── WorkoutViewModel.swift
│   │   └── SettingsViewModel.swift
│   ├── Services/
│   │   ├── PM5Service.swift
│   │   ├── DataStorageService.swift
│   │   └── NetworkService.swift
│   └── Utilities/
│       ├── Extensions/
│       ├── Constants/
│       └── Helpers/
└── Tests/
    ├── UnitTests/
    ├── IntegrationTests/
    └── UITests/
```

### File Naming
- **Models:** `EntityName.swift` (e.g., `WorkoutSession.swift`)
- **Views:** `PurposeView.swift` (e.g., `WorkoutDetailView.swift`) 
- **ViewModels:** `PurposeViewModel.swift` (e.g., `WorkoutDetailViewModel.swift`)
- **Services:** `PurposeService.swift` (e.g., `PM5Service.swift`)
- **Tests:** `ClassNameTests.swift` (e.g., `WorkoutViewModelTests.swift`)

## Documentation Requirements

### Code Documentation

```swift
/// Manages connection and communication with PM5 rowing machines via Bluetooth LE
/// 
/// This service handles device discovery, connection management, and data parsing
/// for Concept2 PM5 performance monitors following the CSAFE protocol.
///
/// ## Usage
/// ```swift
/// let pm5Service = PM5Service()
/// try await pm5Service.connect(to: peripheral)
/// let metrics = try await pm5Service.startWorkout()
/// ```
///
/// - Important: Requires Bluetooth permissions in Info.plist
/// - Note: All methods are MainActor isolated for UI thread safety
@MainActor
class PM5Service: ObservableObject {
    
    /// Connects to the specified PM5 device
    /// - Parameter peripheral: The CBPeripheral representing the PM5 device
    /// - Throws: `PM5Error.connectionFailed` if connection cannot be established
    /// - Returns: Success when connection is fully established and services are discovered
    func connect(to peripheral: CBPeripheral) async throws {
        // Implementation
    }
}
```

### README Requirements

Each major component should have inline documentation explaining:
- Purpose and responsibilities
- Key methods and their usage
- Error conditions and handling
- Dependencies and relationships
- Testing approach

## Security Requirements

### Data Protection
```swift
// ✅ Never log sensitive workout data
logger.info("Workout started") // ✅ OK
logger.debug("User heart rate: \(heartRate)") // ❌ NEVER

// ✅ Secure data storage
private func saveWorkoutData(_ data: WorkoutData) {
    let encrypted = try encrypt(data)
    keychain.save(encrypted, for: "workout_\(data.id)")
}
```

### Bluetooth Security
```swift
// ✅ Validate all incoming data
func parseWorkoutMetrics(from data: Data) throws -> WorkoutMetrics {
    guard data.count >= CSAFEConstants.minimumResponseLength else {
        throw PM5Error.dataParsingFailed
    }
    
    guard isValidCSAFEResponse(data) else {
        throw PM5Error.dataParsingFailed  
    }
    
    return try decodeMetrics(from: data)
}
```

## Performance Standards

### Memory Management
- Use `weak` references for delegates and closures
- Implement proper cleanup in `deinit`
- Profile memory usage during BLE data streaming

### UI Performance
- Keep UI updates on `@MainActor`
- Use lazy loading for large data sets
- Implement proper list virtualization for workout history

## Code Quality Gates - Linting Requirements

### MANDATORY LINTING COMPLIANCE

**CRITICAL REQUIREMENT:** No code can be marked as "Done", "Complete", or "Ready for Review" without passing linting checks.

### Linting Configuration

All iOS code MUST comply with the SwiftLint configuration at `ios-app/.swiftlint.yml`. This configuration enforces:

- **Code Complexity:** Maximum cyclomatic complexity of 10
- **File Organization:** Maximum 400 lines per file, 200 lines per type
- **Naming Standards:** Consistent identifier and type naming
- **Safety Rules:** No force unwrapping, no print statements in production
- **Code Quality:** Proper whitespace, syntax sugar usage, and modern Swift patterns

### Definition of Done - Linting Checklist

**Before ANY story, task, or code change can be marked complete:**

1. **✅ Zero Linting Errors:** Code must have ZERO error-level violations
   ```bash
   swiftlint lint --strict  # Must pass with exit code 0
   ```

2. **✅ Minimal Warnings:** Maximum 5 warning-level violations per file
   ```bash
   swiftlint lint --reporter json | jq '.[] | select(.severity=="Warning")' | wc -l
   ```

3. **✅ Documentation:** All linting suppressions must be documented
   ```swift
   // swiftlint:disable:next line force_unwrapping
   // Reason: API guarantees non-nil response after successful authentication
   let token = response.authToken!
   ```

### Linting Workflow Integration

**Developer Workflow:**
1. **Pre-Commit:** Run `swiftlint lint` locally before committing
2. **Pre-Push:** Run `swiftlint lint --strict` before pushing
3. **Pre-Review:** Include linting report in PR description
4. **Pre-Done:** QA must verify linting compliance

**AI Agent Workflow:**
1. **During Development:** Run linting after each file modification
2. **Before Task Completion:** Execute full linting validation
3. **In Story Completion:** Include linting report in Dev Agent Record
4. **QA Validation:** QA Agent must verify zero errors, acceptable warnings

### Linting Violation Resolution

**If linting violations exist:**

1. **Refactor First:** Always attempt to refactor code to comply
2. **Split Large Files:** Break down files exceeding size limits into logical components
3. **Reduce Complexity:** Extract methods, use guard statements, simplify logic
4. **Suppress Sparingly:** Only disable rules with documented justification

**Acceptable Suppressions (with documentation):**
- Legacy code migration (temporary)
- Third-party SDK requirements
- Performance-critical sections (benchmarked)

**Unacceptable Suppressions:**
- Convenience or laziness
- "Will fix later" without tracked ticket
- Suppressing safety rules (force_unwrapping, implicitly_unwrapped_optional)

### Enforcement Mechanisms

**Automated Enforcement:**
```yaml
# CI/CD Pipeline (Story 1.2 requirement)
- name: SwiftLint Check
  run: |
    swiftlint lint --strict --reporter junit > linting-report.xml
    if [ $? -ne 0 ]; then
      echo "❌ Linting failed - Story cannot be marked as Done"
      exit 1
    fi
```

**Manual Enforcement:**
- **Developer:** Cannot mark story as "Ready for Review" with linting errors
- **QA:** Must reject stories with unresolved linting violations
- **Scrum Master:** Cannot create next story if previous has linting debt
- **Product Owner:** Cannot accept story with linting violations

### Progressive Linting Adoption

**For Existing Code (Brownfield):**
1. **Phase 1:** Fix all errors (mandatory)
2. **Phase 2:** Reduce warnings to <10 per file
3. **Phase 3:** Achieve full compliance

**For New Code (Greenfield):**
- **100% compliance from day one**
- **Zero tolerance for new violations**

### Linting Metrics Tracking

**Track in Dev Agent Record:**
```markdown
### Linting Compliance Report
- Files Analyzed: 11
- Errors: 0 ✅
- Warnings: 3 (acceptable - documented)
- Suppressed Rules: 1 (force_unwrapping - line 234 - API guarantee)
- SwiftLint Version: 0.54.0
- Compliance Status: PASSED ✅
```

## Compliance & Enforcement

**Automated Checks:**
- SwiftLint runs on every commit
- Unit test coverage measured on CI/CD
- UI tests run nightly

**Manual Reviews:**
- All pull requests require architecture review
- TDD compliance verified during code review
- Security patterns reviewed for Bluetooth code

**Violation Consequences:**
- Failed linting blocks merge
- Below 90% coverage blocks release
- Security violations require immediate fix

---

*This document is living and will evolve with the project. All developers must stay current with updates.*