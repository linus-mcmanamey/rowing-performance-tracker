# Development Environment Setup

Complete guide for setting up the Rowing Performance Tracker development environment.

## 🚨 **DEVELOPER PROTOCOL - READ FIRST**

**⚠️ CRITICAL:** Before implementing ANY story, ALWAYS:
1. **Check GitHub issue comments** for handoff notes and implementation instructions
2. **Read the complete story document** in `docs/stories/` 
3. **Review all issue comments** for validation results, context, and specific guidance

**Never start coding without reading GitHub issue comments first!** The Scrum Master and Product Owner provide essential handoff instructions and validation context in issue comments.

## Prerequisites

### System Requirements
- **macOS**: 12.0+ (Monterey or later)
- **Xcode**: 14.0+ with iOS 15 SDK
- **Git**: 2.30+ (included with Xcode Command Line Tools)
- **Hardware**: Mac with Apple Silicon or Intel processor

### Optional but Recommended
- **PM5 Rowing Machine**: For full testing capabilities
- **iOS Device**: Physical device for Bluetooth testing
- **GitHub Account**: For contributing to the project

## Quick Setup

### 1. Install Xcode
```bash
# Install from App Store or Apple Developer Portal
# Ensure iOS 15.0+ SDK is available
xcode-select --install  # Install command line tools if needed
```

### 2. Clone Repository
```bash
git clone https://github.com/linus-mcmanamey/rowing-performance-tracker.git
cd rowing-performance-tracker
```

### Project Links
- **Repository**: https://github.com/linus-mcmanamey/rowing-performance-tracker
- **Issues**: https://github.com/linus-mcmanamey/rowing-performance-tracker/issues
- **Project Board**: https://github.com/users/linus-mcmanamey/projects/3

## 🔧 **XCODE MCP SERVER REQUIREMENT**

**⚠️ MANDATORY:** All developers and testers MUST use the Xcode MCP server for any Xcode operations:

### Why Use Xcode MCP Server?
- **Automated Build Management**: Handles complex build configurations
- **Consistent Test Execution**: Standardized testing across environments
- **Better Error Handling**: Provides detailed build and test feedback
- **CI/CD Integration**: Essential for automated pipeline operations
- **Cross-Platform Compatibility**: Works seamlessly with Claude Code IDE

### Required Operations via MCP Server:
- ✅ **Building projects**: Use MCP build commands instead of Xcode GUI
- ✅ **Running tests**: Use MCP test commands for consistent results
- ✅ **Device management**: Use MCP for simulator and device operations
- ✅ **Code signing**: Use MCP for automated signing workflows
- ✅ **Debugging**: Use MCP for structured debugging and logging

### Setup Instructions:
1. **Ensure Claude Code is installed** with Xcode MCP server enabled
2. **Verify MCP server connection**: Run `mcp__XcodeBuildMCP__diagnostic` to confirm setup
3. **Use MCP commands**: Always prefer MCP server commands over manual Xcode operations

### Common MCP Commands for This Project:
```bash
# Discover projects and schemes
mcp__XcodeBuildMCP__discover_projs
mcp__XcodeBuildMCP__list_schems_proj

# Build for simulator
mcp__XcodeBuildMCP__build_sim_name_proj

# Run tests
mcp__XcodeBuildMCP__test_sim_name_proj

# Build for device
mcp__XcodeBuildMCP__build_dev_proj

# Install and launch on device
mcp__XcodeBuildMCP__install_app_device
mcp__XcodeBuildMCP__launch_app_device
```

**❌ DO NOT:**
- Use Xcode GUI for builds or tests in development workflow
- Manually run xcodebuild commands
- Rely on Xcode's built-in testing without MCP coordination

**💡 Benefits:**
- Consistent build environments across team
- Automated error reporting and resolution
- Integration with CI/CD pipeline
- Better debugging and logging capabilities

## 🐙 **GITHUB MCP SERVER REQUIREMENT**

**⚠️ MANDATORY:** All agents and developers MUST use the GitHub MCP server for repository and project interactions:

### Why Use GitHub MCP Server?
- **Automated Repository Management**: Handles complex GitHub operations programmatically
- **Consistent Issue/PR Workflow**: Standardized GitHub interactions across team
- **Enhanced Error Handling**: Better feedback for GitHub API operations
- **CI/CD Integration**: Essential for automated GitHub workflows
- **Multi-Repository Support**: Seamless operations across multiple repositories

### Required Operations via GitHub MCP Server:
- ✅ **Repository Management**: Create, fork, search repositories
- ✅ **Issue Management**: Create, update, comment on issues
- ✅ **Pull Request Operations**: Create, review, merge, update PRs
- ✅ **File Operations**: Read, write, update files in repositories
- ✅ **Branch Management**: Create branches, manage branch operations
- ✅ **Release Management**: Create and manage releases
- ✅ **Search Operations**: Search across repositories, code, issues, users

### Setup Instructions:
1. **Ensure Claude Code is installed** with GitHub MCP server enabled
2. **Configure GitHub authentication**: Ensure proper GitHub token is configured
3. **Verify MCP server connection**: Test GitHub MCP operations
4. **Use MCP commands**: Always prefer GitHub MCP commands over manual GitHub operations

### GitHub Project Information:
- **Repository Owner**: `linus-mcmanamey`
- **Repository Name**: `rowing-performance-tracker`
- **Issues URL**: https://github.com/linus-mcmanamey/rowing-performance-tracker/issues
- **Project Board URL**: https://github.com/users/linus-mcmanamey/projects/3

### Common GitHub MCP Commands for This Project:
```bash
# Repository operations
mcp__github__get_file_contents --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__create_or_update_file --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__push_files --owner linus-mcmanamey --repo rowing-performance-tracker

# Issue management (Issues: https://github.com/linus-mcmanamey/rowing-performance-tracker/issues)
mcp__github__list_issues --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__create_issue --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__update_issue --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__add_issue_comment --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__get_issue --owner linus-mcmanamey --repo rowing-performance-tracker --issue_number <issue-number>

# Pull request operations
mcp__github__list_pull_requests --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__create_pull_request --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__get_pull_request --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__merge_pull_request --owner linus-mcmanamey --repo rowing-performance-tracker

# Branch management
mcp__github__create_branch --owner linus-mcmanamey --repo rowing-performance-tracker
mcp__github__list_commits --owner linus-mcmanamey --repo rowing-performance-tracker

# Search operations
mcp__github__search_repositories --query "rowing performance tracker"
mcp__github__search_code --q "PM5Controller repo:linus-mcmanamey/rowing-performance-tracker"
mcp__github__search_issues --q "is:open repo:linus-mcmanamey/rowing-performance-tracker"

# Project-specific searches
mcp__github__search_issues --q "is:open repo:linus-mcmanamey/rowing-performance-tracker label:epic"
mcp__github__search_issues --q "is:open repo:linus-mcmanamey/rowing-performance-tracker label:story"
```

**❌ DO NOT:**
- Use manual GitHub web interface for programmatic operations
- Use git commands for GitHub-specific operations (issues, PRs, releases)
- Manually manage GitHub workflows that can be automated via MCP
- Use curl or other manual API calls to GitHub when MCP commands exist

**💡 Benefits:**
- Consistent GitHub operations across all team members and agents
- Automated error handling and retry logic
- Structured data exchange with proper validation
- Integration with development workflows and CI/CD
- Better tracking and logging of GitHub operations

### 3. Open Project
```bash
open ios-app/d_n_w.xcodeproj
```

### 4. Configure Signing
1. Select the project root in Xcode
2. Choose your development team under "Signing & Capabilities"
3. Ensure bundle identifier is unique (change if needed)

### 5. Build and Run
- **Simulator**: Select iOS Simulator and press `Cmd+R`
- **Device**: Connect iOS device, select it, and press `Cmd+R`

## Detailed Setup

### Xcode Configuration

#### Build Settings
- **iOS Deployment Target**: 15.0 (minimum supported)
- **Swift Language Version**: Swift 5.5+
- **Architecture**: Universal (arm64 + x86_64)

#### Capabilities Required
- **Background Modes**: Bluetooth peripheral/central
- **Bluetooth**: Always usage permission

#### Signing Configuration
```
Team: [Your Development Team]
Bundle Identifier: com.surfseer.rowing-performance-tracker
Provisioning Profile: Automatic
Code Signing Identity: Apple Development
```

### Project Structure

#### iOS App (`ios-app/`)
```
d_n_w.xcodeproj          # Xcode project file
d_n_w/                   # Main app source
  ├── ContentView.swift     # Main UI entry point
  ├── d_n_wApp.swift       # App lifecycle
  ├── PM5/                 # PM5 BLE implementation
  │   ├── PM5Controller.swift
  │   ├── CSAFEProtocol.swift
  │   ├── PM5DataParser.swift
  │   └── PM5DataModels.swift
  ├── Assets.xcassets/     # Images and colors
  ├── Info.plist          # App configuration
  └── d_n_w.entitlements  # App capabilities
d_n_wTests/              # Unit tests
d_n_wUITests/            # UI tests
```

### Development Workflow

#### 1. Feature Development (with GitHub MCP Integration)
```bash
# Create feature branch (can use GitHub MCP for remote branch creation)
git checkout -b feature/your-feature-name

# Alternative: Create branch via GitHub MCP
mcp__github__create_branch --owner linus-mcmanamey --repo rowing-performance-tracker --branch feature/your-feature-name

# Make changes and test
# Commit with clear messages
git add .
git commit -m "feat: add new feature description"

# Push branch
git push origin feature/your-feature-name

# ✅ REQUIRED: Create PR via GitHub MCP (NOT manual GitHub web interface)
mcp__github__create_pull_request --owner linus-mcmanamey --repo rowing-performance-tracker --title "Your Feature Title" --head feature/your-feature-name --base main --body "Feature description"
```

#### 2. Testing (via Xcode MCP Server)
```bash
# ✅ REQUIRED: Use MCP server for all testing
# Run all tests on simulator
mcp__XcodeBuildMCP__test_sim_name_proj --projectPath ios-app/d_n_w.xcodeproj --scheme d_n_w --simulatorName "iPhone 15"

# Run tests on specific device
mcp__XcodeBuildMCP__test_device_proj --projectPath ios-app/d_n_w.xcodeproj --scheme d_n_w --deviceId <device-uuid>

# List available devices
mcp__XcodeBuildMCP__list_devices
mcp__XcodeBuildMCP__list_sims

# ❌ DEPRECATED: Manual testing commands (DO NOT USE)
# Cmd+U in Xcode
# xcodebuild test commands
```

#### 3. Code Quality
- **SwiftLint**: Will be configured in Epic 1.2
- **Code Coverage**: Target 80% minimum
- **Architecture**: Follow MVVM pattern with SwiftUI

## Bluetooth Development

### PM5 Testing Setup

#### Without Physical PM5
1. Use PM5 simulator mode in the app
2. Mock BLE services for unit testing
3. Test UI components independently

#### With Physical PM5
1. **Power on** PM5 monitor
2. **Enable Bluetooth** on iOS device
3. **Grant permissions** when prompted
4. **Pair device** through app interface

#### Bluetooth Debugging
```bash
# Enable Bluetooth logging (macOS)
sudo log config --mode "level:debug" --subsystem com.apple.bluetooth

# Monitor Bluetooth logs
log stream --predicate 'subsystem == "com.apple.bluetooth"'
```

### Common BLE Issues

#### Connection Problems
- Ensure PM5 is in pairing mode
- Check iOS Bluetooth is enabled
- Restart app if connection fails
- Clear Bluetooth cache if persistent issues

#### Permission Issues
- Verify Info.plist has Bluetooth usage descriptions
- Check iOS Settings → Privacy → Bluetooth
- Ensure app has Bluetooth permissions granted

## Testing Strategy

### Running Tests Locally

#### Quick Test Commands
```bash
# Navigate to project directory
cd ios-app

# Run all tests with coverage
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -enableCodeCoverage YES

# Run only unit tests
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing d_n_wTests

# Run specific test class
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing d_n_wTests/PM5ServiceTests
```

#### SwiftLint Local Setup
```bash
# Install SwiftLint via Homebrew
brew install swiftlint

# Run SwiftLint checks
swiftlint lint --path ios-app/d_n_w

# Auto-fix style issues
swiftlint lint --path ios-app/d_n_w --fix

# Run strict mode (as used in CI)
swiftlint lint --path ios-app/d_n_w --strict
```

#### Coverage Reports
```bash
# Generate coverage report
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -enableCodeCoverage YES

# View coverage in Xcode
# Window → Organizer → Coverage Reports

# Extract coverage percentage (requires xcov gem)
gem install xcov
xcov --scheme d_n_w --minimum_coverage_percentage 80
```

#### Using Mock PM5 Service
The project includes a comprehensive mock PM5 service for testing without hardware:

```swift
// Example: Using MockPM5Service in tests
let mockService = MockPM5Service()
await mockService.startScanning()

// Simulate device discovery
let devices = await mockService.discoveredDevices
XCTAssertEqual(devices.count, 1)

// Connect to mock device
await mockService.connect(to: devices.first!)
XCTAssertTrue(mockService.isConnected)

// Generate mock workout data
await mockService.startMockDataGeneration()
// Mock data will be published to subscribers
```

**📚 For detailed testing procedures, see:** [Local Testing Procedures](docs/local-testing-procedures.md)

### Unit Tests
- **PM5Controller**: Connection management
- **CSAFEProtocol**: Command parsing
- **PM5DataParser**: Data conversion
- **UI Components**: SwiftUI view testing
- **MockPM5Service**: 17 comprehensive tests for mock functionality

### Integration Tests
- **End-to-end BLE workflow**
- **UI navigation flows**
- **Data persistence**
- **Mock mode switching**

### Device Testing
- **iOS 15.0**: Minimum supported version
- **iPhone 6S+**: Minimum hardware support
- **iPad**: Verify tablet compatibility

### Coverage Requirements
- **Minimum**: 80% overall code coverage
- **Critical Components**: 100% for PM5 service layer
- **CI Enforcement**: Pipeline fails if coverage drops below threshold

## Build Configurations

### Debug
```
Optimization: None
Debugging: Enabled
Swift Flags: -DDEBUG
Bluetooth Logging: Verbose
```

### Release
```
Optimization: Fastest, Smallest
Debugging: Disabled
Swift Flags: -DRELEASE
Bluetooth Logging: Error Only
```

### Testing
```
Optimization: None
Debugging: Enabled
Swift Flags: -DTESTING
Mock BLE Services: Enabled
```

## Troubleshooting

### Build Issues

#### Swift Compiler Errors
```bash
# Clean build folder
Product → Clean Build Folder (Cmd+Shift+K)

# Reset package cache
File → Packages → Reset Package Caches

# Delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

#### Signing Issues
1. Check Apple Developer account status
2. Verify team membership in Xcode
3. Generate new certificates if expired
4. Ensure unique bundle identifier

### Runtime Issues

#### Bluetooth Connection Failures
1. **Restart Bluetooth**: Settings → Bluetooth → Toggle off/on
2. **Reset Network Settings**: Settings → General → Reset
3. **Clear app data**: Delete and reinstall app
4. **Check PM5 firmware**: Ensure latest PM5 software

#### App Crashes
1. **Check console logs**: Window → Devices and Simulators
2. **Enable exception breakpoints**: Debug → Breakpoints
3. **Review crash logs**: Xcode → Window → Organizer

### Performance Issues

#### Slow BLE Performance
- Check for memory leaks in BLE delegate methods
- Verify proper cleanup of BLE connections
- Monitor CPU usage during data streaming
- Optimize data parsing algorithms

#### UI Lag
- Profile with Instruments
- Check for main thread blocking
- Optimize SwiftUI view updates
- Reduce unnecessary recomputations

## Development Tools

### Recommended Tools
- **Instruments**: Performance profiling
- **Console.app**: System log monitoring
- **Bluetooth Explorer**: BLE debugging (Xcode Additional Tools)
- **SF Symbols**: Icon resources

### Useful Commands
```bash
# Check iOS simulator list
xcrun simctl list devices

# Boot specific simulator
xcrun simctl boot "iPhone 15"

# Install app on simulator
xcrun simctl install booted path/to/app.app

# View device logs
xcrun simctl spawn booted log stream
```

## Contributing Guidelines

### Code Standards
- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add inline documentation for public APIs
- Maintain consistent indentation (4 spaces)

### Commit Messages
```
feat: add new feature
fix: resolve bug issue
docs: update documentation
test: add test coverage
refactor: code cleanup
```

### Pull Request Process
1. Create feature branch
2. Implement changes with tests
3. Update documentation
4. Submit PR with clear description
5. Address review feedback
6. Merge after approval

## Resources

### Documentation
- [Swift Documentation](https://swift.org/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Core Bluetooth Programming Guide](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/)
- [PM5 BLE Specification](docs/PM5_BLE_Implementation.md)

### Community
- **Repository**: https://github.com/linus-mcmanamey/rowing-performance-tracker
- **Issues Tracker**: https://github.com/linus-mcmanamey/rowing-performance-tracker/issues
- **Project Board**: https://github.com/users/linus-mcmanamey/projects/3
- **Discussions**: https://github.com/linus-mcmanamey/rowing-performance-tracker/discussions

---

*Need help? Open an issue or start a discussion on GitHub.*