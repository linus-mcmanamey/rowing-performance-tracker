# Rowing Performance Tracker

A comprehensive rowing performance tracking platform that connects iOS devices to PM5 rowing machines via Bluetooth for real-time data capture, analysis, and coaching insights.

## 🎯 Project Overview

The Rowing Performance Tracker is designed to bridge the gap between PM5 rowing machines and modern performance analytics. It provides athletes and coaches with real-time performance data, historical analysis, and multi-athlete monitoring capabilities.

### Key Features

- **Real-time PM5 Connectivity**: Direct Bluetooth connection to Concept2 PM5 monitors
- **Live Performance Tracking**: Track stroke rate, split times, distance, and power output
- **Athlete Dashboard**: Individual performance metrics and workout history
- **Coach Dashboard**: Multi-athlete monitoring and team management (Phase 2)
- **Historical Analytics**: Performance trends and improvement tracking
- **Cross-Platform Sync**: Data synchronization across devices (Phase 2)

## 🏗️ Architecture

This project uses a monorepo structure with clear separation of concerns:

```
rowing-performance-tracker/
├── ios-app/                 # iOS application (SwiftUI)
│   ├── d_n_w/              # Main iOS app source
│   ├── d_n_w.xcodeproj/    # Xcode project
│   ├── d_n_wTests/         # Unit tests
│   └── d_n_wUITests/       # UI tests
├── backend-services/        # Backend services (Phase 2)
├── web-dashboard/          # Coach web dashboard (Phase 2)
├── shared-types/           # Shared data models and types
└── docs/                   # Architecture and API documentation
```

### Technology Stack

- **iOS**: Swift 5.5+, SwiftUI, iOS 15.0+
- **Bluetooth**: Core Bluetooth with PM5 GATT protocol
- **Backend**: Node.js/Express with GraphQL (Phase 2)
- **Database**: PostgreSQL with real-time sync (Phase 2)
- **Web**: React/Next.js for coach dashboard (Phase 2)

## 🚀 Quick Start

### Prerequisites

- Xcode 14.0+
- iOS device or simulator (iOS 15.0+)
- PM5-equipped rowing machine (for full functionality)
- macOS 12.0+ (for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/linus-mcmanamey/rowing-performance-tracker.git
   cd rowing-performance-tracker
   ```

2. **Open iOS project**
   ```bash
   open ios-app/d_n_w.xcodeproj
   ```

3. **Build and run**
   - Select your target device/simulator
   - Press `Cmd+R` to build and run
   - Grant Bluetooth permissions when prompted

### First Launch

1. **Grant Bluetooth Permission**: The app will request Bluetooth access for PM5 connectivity
2. **Navigate to PM5 Tab**: Use the PM5 tab to scan for nearby rowing machines
3. **Connect to PM5**: Select your PM5 device from the scan results
4. **Start Rowing**: Begin your workout and watch real-time metrics

## 📱 iOS App Structure

### Core Components

- **HomeView**: Main dashboard with quick actions and status
- **PM5TestView**: Bluetooth connection and real-time data display
- **PerformanceView**: Analytics and historical data
- **SettingsView**: App configuration and preferences

### PM5 Integration

The app includes a complete PM5 Bluetooth Low Energy implementation:

- **PM5Controller**: Main BLE connection manager
- **CSAFEProtocol**: CSAFE command protocol implementation
- **PM5DataParser**: Real-time data parsing and processing
- **PM5DataModels**: Structured data models for metrics

## 🧪 Testing

### Running Tests

```bash
# Unit Tests
Cmd+U in Xcode

# Specific test suite
xcodebuild test -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage

- Target: 80% code coverage
- Focus areas: PM5 connectivity, data parsing, UI components
- Mock BLE services for testing without hardware

## 📖 Development Guide

### Code Standards

- **Swift Style**: Follow Swift API Design Guidelines
- **Architecture**: MVVM pattern with SwiftUI
- **Testing**: XCTest framework with mock BLE services
- **Documentation**: Inline documentation for public APIs

### Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** changes (`git commit -m 'Add amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Workflow

1. **Story Assignment**: All development follows user stories in GitHub Issues
2. **Branch Strategy**: Feature branches from main
3. **Code Review**: All PRs require review
4. **Testing**: Tests must pass before merge
5. **Documentation**: Update relevant docs with changes

## 🗺️ Roadmap

### Epic 1: Foundation & Core Infrastructure *(Current)*
- [x] Project setup and iOS app initialization
- [ ] CI/CD pipeline and testing framework
- [ ] Authentication service and user management
- [ ] Core BLE connection framework
- [ ] Backend health check and basic API

### Epic 2: Real-time Data Capture & Display
- [ ] PM5 real-time data streaming
- [ ] Live workout dashboard
- [ ] Workout session management
- [ ] Data persistence layer

### Epic 3: Coach Dashboard & Multi-Athlete Monitoring
- [ ] Web-based coach dashboard
- [ ] Multi-athlete live monitoring
- [ ] Team management features
- [ ] Real-time notifications

### Epic 4: Data Persistence & Synchronization
- [ ] Cloud data synchronization
- [ ] Offline capability
- [ ] Data export features
- [ ] Backup and recovery

### Epic 5: Team Management & Historical Analytics
- [ ] Advanced analytics dashboard
- [ ] Performance trend analysis
- [ ] Team comparison tools
- [ ] Custom reporting

## 🔧 Configuration

### Environment Setup

See [DEVELOPMENT.md](DEVELOPMENT.md) for detailed development environment setup instructions.

### Build Configuration

- **Debug**: Development builds with debugging enabled
- **Release**: Production builds optimized for App Store
- **Testing**: Special configuration for automated testing

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- **Issues**: [GitHub Issues](https://github.com/linus-mcmanamey/rowing-performance-tracker/issues)
- **Discussions**: [GitHub Discussions](https://github.com/linus-mcmanamey/rowing-performance-tracker/discussions)
- **Email**: support@surfseer.com

## 🎯 Project Status

**Current Phase**: Epic 1 - Foundation & Core Infrastructure
**Version**: 1.0.0-alpha
**Last Updated**: August 2025

---

*Built with ❤️ for the rowing community*