

## Data Flow Architecture

### MVP Data Flow (SwiftData + CloudKit)
```
iOS App (SwiftData) ←→ CloudKit Private Database ←→ Other User Devices
       ↓
PM5 Device (Bluetooth LE)
```

### Future Enhanced Flow (Phase 2)
```
iOS App (SwiftData) ←→ CloudKit ←→ Backend Analytics ←→ Web Dashboard
       ↓                              ↓
PM5 Device (BLE)                Advanced Reports
```

## Technology Decisions

### Why SwiftData Over Core Data?
- **Modern Swift syntax** - No Objective-C legacy
- **Type safety** - Compile-time safety for data models
- **CloudKit integration** - Built-in sync capabilities
- **Better performance** - Optimized for Swift concurrency
- **Simplified queries** - Swift-native predicate system

### Why CloudKit Over Custom Backend?
- **Zero maintenance** - Apple handles all infrastructure
- **Native integration** - Seamless with Apple ecosystem
- **Automatic scaling** - Handles traffic spikes automatically
- **Security by default** - Enterprise-grade encryption
- **Cost efficiency** - Generous free tier, usage-based pricing
- **User experience** - No account creation, immediate access

### Device Compatibility Strategy
- **iOS 17+ devices**: Full SwiftData capabilities
- **iOS 15-16 devices**: Core Data fallback with CloudKit sync
- **Graceful degradation** - Older devices get core functionality
- **Progressive enhancement** - Advanced features on newer devices# Tech Stack

## Technology Stack Table - CloudKit + SwiftData Strategy

### Core iOS Platform (MVP - Phase 1)
| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| Frontend Language | Swift | 5.5+ | iOS app development | Native performance, existing codebase, iOS 15 compatible |
| Frontend Framework | SwiftUI + UIKit Hybrid | iOS 15+ | UI framework | Modern declarative UI, UIKit fallbacks for older devices |
| UI Component Library | Native SwiftUI/UIKit | iOS 15+ | UI components | Platform consistency, older device support |
| State Management | Combine + @Published | iOS 15+ | Reactive state | Built-in, no dependencies, iOS 15 compatible |
| Device Support | iOS 15.0+ | iPhone 6S+ | Target devices | Supports 2015+ devices (hand-me-downs) |
| **Local Data Storage** | **SwiftData** | **iOS 17+** | **Primary data persistence** | **Modern Swift-native ORM, type-safe, performant** |
| **Cloud Sync & Backup** | **CloudKit** | **iOS 15+** | **Data synchronization** | **Native Apple ecosystem, automatic sync, secure** |
| **Authentication** | **CloudKit + Apple ID** | **iOS 15+** | **User authentication** | **Zero-config, secure, platform-native** |
| BLE Communication | Core Bluetooth | iOS 15+ | PM5 device connectivity | Direct hardware communication |
| Frontend Testing | XCTest | Latest | iOS testing | Native, integrated |
| Build Tool | Xcode Build | 14.0+ | iOS builds | Native toolchain, iOS 15 targeting |
| CI/CD | GitHub Actions | Latest | Automation | Integrated with repo |
| Code Quality | SwiftLint | Latest | Code standards | Consistent coding style |
| Monitoring | OSLog + Sentry | Latest | Error tracking | Native logging + crash reporting |

### Future Backend Services (Phase 2 - Optional)
| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| Backend Language | TypeScript/Node.js | 20 LTS | Advanced analytics | Only if CloudKit limitations reached |
| Backend Framework | Fastify | 4.x | REST API server | High performance for analytics |
| Database | PostgreSQL + TimescaleDB | 15+ | Advanced analytics | Time-series analysis for large datasets |
| Web Dashboard | React + Next.js | Latest | Coach dashboard | Cross-platform coaching tools |
| Deployment | Docker + AWS ECS | Latest | Cloud hosting | Scalable infrastructure |

## Architecture Strategy

### Phase 1: CloudKit-First MVP
**Focus**: Pure iOS app with CloudKit for all data needs

**Benefits:**
- ✅ **Zero backend complexity** - CloudKit handles all server-side logic
- ✅ **Automatic user management** - Apple ID integration, no registration flows
- ✅ **Native data sync** - Seamless across user's Apple devices
- ✅ **Built-in security** - Apple's enterprise-grade security
- ✅ **Offline-first** - SwiftData works offline, syncs when connected
- ✅ **Cost effective** - No server infrastructure costs

**SwiftData + CloudKit Integration:**
```swift
// SwiftData handles local storage and CloudKit sync
@Model
class RowingSession {
    @Attribute(.unique) var id: UUID
    var athleteID: UUID
    var startTime: Date
    var totalDistance: Double
    // CloudKit automatically syncs when configured
}
```

### Phase 2: Optional Backend Enhancement
**Trigger**: When CloudKit limitations are reached (advanced analytics, coach dashboards)

**Migration Path:**
- Keep SwiftData + CloudKit as primary
- Add backend for advanced features only
- Maintain iOS-first architecture
