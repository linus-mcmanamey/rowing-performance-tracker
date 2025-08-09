# Epic 1: Foundation & Core Infrastructure

Establish the technical foundation and core infrastructure needed for the rowing performance tracking platform. This epic delivers the iOS app skeleton with authentication, basic PM5 BLE connectivity, and a simple health check to verify the system is operational. This provides the groundwork for all subsequent features while delivering immediate value through basic connectivity testing.

## Story 1.1: Project Setup and iOS App Initialization

As a developer,
I want to set up the project repository and iOS app foundation,
so that we have a properly structured codebase ready for feature development.

### Acceptance Criteria
1: Monorepo created with folders for ios-app, web-dashboard, backend-services, and shared-types
2: iOS app initialized using Swift/SwiftUI with minimum iOS 15 deployment target
3: Git repository initialized with .gitignore for iOS, Node.js, and common IDE files
4: Basic SwiftUI app runs successfully showing "Rowing Performance Tracker" home screen
5: README.md created with project overview, setup instructions, and architecture diagram
6: Package dependencies configured (Swift Package Manager for iOS)
7: Development environment setup documented for new developers
8: Basic app icon and launch screen placeholder added
9: Xcode project configured with appropriate build settings and signing

## Story 1.2: CI/CD Pipeline and Testing Framework

As a developer,
I want automated testing and deployment pipelines configured,
so that we maintain code quality and can deploy reliably.

### Acceptance Criteria
1: GitHub Actions workflow created for iOS app that runs on every PR
2: XCTest framework integrated with sample unit test that passes
3: SwiftLint configured with agreed-upon style rules
4: Test coverage reporting implemented with 80% threshold enforcement
5: Automated build process creates test builds for iOS
6: Mock PM5 BLE service created for testing without physical hardware
7: Documentation for running tests locally
8: Pipeline fails if tests fail or coverage drops below 80%

## Story 1.3: Authentication Service and User Management

As a user (athlete, coach, or admin),
I want to securely log into the app,
so that I can access my appropriate features and data.

### Acceptance Criteria
1: Backend authentication service implemented with JWT tokens
2: iOS app login screen created with email/password fields
3: Three user roles implemented: Athlete, Coach, Admin
4: Registration flow for new users with role selection
5: Secure token storage in iOS Keychain
6: Auto-login for returning users with valid tokens
7: Logout functionality clears stored credentials
8: Password reset flow via email
9: Login errors displayed clearly to users
10: Unit tests cover all authentication flows

## Story 1.4: Core BLE Connection Framework

As an athlete,
I want to connect my iPhone to a PM5 rowing machine,
so that I can start capturing my performance data.

### Acceptance Criteria
1: CoreBluetooth integrated into iOS app with proper permissions
2: BLE scanner discovers nearby PM5 devices
3: PM5 devices displayed in a list with signal strength
4: Basic connection established to selected PM5
5: Connection status displayed in UI (scanning, connecting, connected, disconnected)
6: Automatic reconnection on disconnect
7: Error handling for common BLE issues
8: Unit tests using mock BLE framework
9: Documentation of PM5 BLE service UUIDs and characteristics

## Story 1.5: Backend Health Check and Basic API

As a developer,
I want basic backend services running,
so that the iOS app can communicate with our servers.

### Acceptance Criteria
1: Node.js/Express backend service created with /health endpoint
2: Service containerized with Dockerfile
3: Basic AWS infrastructure provisioned (VPC, ECS cluster)
4: Service deployed to AWS ECS using Terraform
5: API Gateway configured with public endpoint
6: iOS app makes successful health check call
7: GraphQL endpoint configured with basic schema
8: Environment-based configuration (dev, staging, prod)
9: Structured logging implemented
10: Basic error handling middleware
