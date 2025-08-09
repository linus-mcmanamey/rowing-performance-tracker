# Dependencies

## Overview

The Rowing Performance Tracker iOS app is designed with minimal external dependencies to maintain stability, security, and build simplicity.

## Current Dependencies

### Built-in iOS Frameworks
- **SwiftUI**: Modern UI framework (iOS 15.0+)
- **Core Bluetooth**: BLE connectivity for PM5 communication
- **Combine**: Reactive programming for state management
- **Foundation**: Core system services

### Internal Components
- **PM5 BLE Stack**: Custom implementation in `d_n_w/PM5/`
  - `PM5Controller.swift`: Main BLE connection manager
  - `CSAFEProtocol.swift`: CSAFE command protocol
  - `PM5DataParser.swift`: Data parsing and processing
  - `PM5DataModels.swift`: Structured data models

## Dependency Management

### Swift Package Manager
The project uses Swift Package Manager (SPM) for external dependencies when needed:

```swift
// Package.swift (when needed)
// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "d_n_w",
    platforms: [.iOS(.v15)],
    dependencies: [
        // External dependencies will be added here as needed
    ],
    targets: [
        .executableTarget(
            name: "d_n_w",
            dependencies: []
        )
    ]
)
```

### Adding New Dependencies

1. **Evaluate Necessity**: Ensure the dependency provides significant value
2. **Check License Compatibility**: Verify license is compatible with project
3. **Security Review**: Check for known vulnerabilities
4. **Add via Xcode**: File → Add Package Dependencies
5. **Document Changes**: Update this file with new dependencies

### Future Dependencies

Planned dependencies for upcoming features:

#### Phase 1 Extensions
- **Networking**: URLSession (built-in) for backend communication
- **Testing**: XCTest (built-in) for comprehensive testing

#### Phase 2 Additions
- **Charts**: SwiftUI Charts for performance visualization
- **Authentication**: Potential Auth0 SDK for user management
- **Analytics**: Firebase Analytics for usage tracking (optional)

## Dependency Guidelines

### Selection Criteria
- **Stability**: Mature, well-maintained packages
- **Performance**: Minimal impact on app performance
- **License**: Compatible with project licensing
- **Swift**: Native Swift packages preferred over Objective-C
- **iOS Support**: Full iOS 15.0+ compatibility

### Avoiding Dependencies
Prefer built-in solutions when possible:
- Use Foundation for networking over third-party HTTP libraries
- Use Core Data or SwiftData over external ORMs
- Use SwiftUI Charts over third-party charting libraries
- Use Core Bluetooth directly rather than abstraction layers

## Testing Dependencies

### Development Only
- **XCTest**: Built-in testing framework
- **Mock Frameworks**: Custom mocks preferred over external libraries

### Build Tools
- **Xcode Build System**: Native build tooling
- **Swift Package Manager**: Dependency resolution
- **fastlane**: CI/CD automation (future consideration)

## Monitoring

- Regular dependency audits for security vulnerabilities
- Swift package updates managed through Xcode
- Version locking for stability in releases
- Automated dependency checking in CI pipeline (future)

---

*Last Updated: August 2025*