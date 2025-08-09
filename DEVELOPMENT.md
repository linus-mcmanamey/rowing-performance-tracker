# Development Environment Setup

Complete guide for setting up the Rowing Performance Tracker development environment.

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

#### 1. Feature Development
```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and test
# Commit with clear messages
git add .
git commit -m "feat: add new feature description"

# Push and create PR
git push origin feature/your-feature-name
```

#### 2. Testing
```bash
# Run all tests
Cmd+U in Xcode

# Run specific test suite
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 15'

# Test on device (requires physical iOS device)
xcodebuild test -scheme d_n_w -destination 'platform=iOS,id=<device-udid>'
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

### Unit Tests
- **PM5Controller**: Connection management
- **CSAFEProtocol**: Command parsing
- **PM5DataParser**: Data conversion
- **UI Components**: SwiftUI view testing

### Integration Tests
- **End-to-end BLE workflow**
- **UI navigation flows**
- **Data persistence**

### Device Testing
- **iOS 15.0**: Minimum supported version
- **iPhone 6S+**: Minimum hardware support
- **iPad**: Verify tablet compatibility

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
- [GitHub Discussions](https://github.com/linus-mcmanamey/rowing-performance-tracker/discussions)
- [Issues Tracker](https://github.com/linus-mcmanamey/rowing-performance-tracker/issues)

---

*Need help? Open an issue or start a discussion on GitHub.*