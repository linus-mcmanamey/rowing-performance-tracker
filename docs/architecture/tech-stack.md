# Tech Stack

## Technology Stack Table
| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| Frontend Language | Swift | 5.5+ | iOS app development | Native performance, existing codebase, iOS 15 compatible |
| Frontend Framework | SwiftUI + UIKit Hybrid | iOS 15+ | UI framework | Modern declarative UI, UIKit fallbacks for older devices |
| UI Component Library | Native SwiftUI/UIKit | iOS 15+ | UI components | Platform consistency, older device support |
| State Management | Combine + @Published | iOS 15+ | Reactive state | Built-in, no dependencies, iOS 15 compatible |
| Device Support | iOS 15.0+ | iPhone 6S+ | Target devices | Supports 2015+ devices (hand-me-downs) |
| Backend Language | TypeScript/Node.js | 20 LTS | Server development | Full-stack JS, rapid development |
| Backend Framework | Fastify | 4.x | REST/WebSocket server | High performance, low overhead |
| API Style | REST + WebSocket | - | Client-server communication | Simple REST, real-time WS |
| Database | PostgreSQL + TimescaleDB | 15+ | Data persistence | Reliable, time-series support |
| Cache | Redis | 7+ | Session cache, pub/sub | Fast, versatile |
| File Storage | Local FS → S3 | - | File storage | Progressive migration path |
| Authentication | CloudKit (iOS) / JWT (Backend) | - | User authentication | Platform-native + standard |
| Frontend Testing | XCTest | Latest | iOS testing | Native, integrated |
| Backend Testing | Jest + Supertest | 29+ | API testing | Comprehensive, fast |
| E2E Testing | Playwright | Latest | Dashboard testing | Modern, reliable |
| Build Tool | Xcode Build | 14.0+ | iOS builds | Native toolchain, iOS 15 targeting |
| Bundler | Vite | 5+ | Dashboard bundling | Fast, modern |
| IaC Tool | Docker Compose → CDK | Latest | Infrastructure | Simple start, cloud path |
| CI/CD | GitHub Actions | Latest | Automation | Integrated with repo |
| Monitoring | Sentry + Prometheus | Latest | Observability | Comprehensive monitoring |
| Logging | Console → CloudWatch | Latest | Log aggregation | Progressive enhancement |
| CSS Framework | Tailwind CSS | 3+ | Dashboard styling | Utility-first, fast |
