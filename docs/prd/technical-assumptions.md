# Technical Assumptions

## Repository Structure: Monorepo
Single repository containing iOS app, web dashboard, backend services, and shared type definitions. This enables atomic commits across the stack and simplified dependency management.

## Service Architecture
Microservices architecture deployed on AWS with the following services:
- **Data Ingestion Service**: Handles real-time data streaming from iOS devices
- **User Management Service**: Authentication, authorization, team management  
- **Analytics Service**: ClickHouse integration for time-series data queries
- **Real-time Service**: WebSocket connections for live dashboard updates
- **Sync Service**: Handles offline data synchronization

All services containerized and deployed using AWS ECS/Fargate with Infrastructure as Code (Terraform).

## Testing Requirements
Test-Driven Development (TDD) approach with comprehensive testing pyramid:
- **Unit Tests**: 80%+ code coverage for business logic
- **Integration Tests**: API endpoints, service interactions
- **UI Tests**: Critical user flows, real-time update scenarios
- **E2E Tests**: Complete workout sessions from connection to data storage
- **Performance Tests**: Real-time latency, concurrent connection limits
- **BLE Mock Framework**: Simulated PM5 devices for consistent testing

Automated CI/CD pipeline runs all tests on every pull request.

## Additional Technical Assumptions and Requests
- Use Combine framework for reactive programming in SwiftUI
- Implement WebSocket connections for real-time data streaming
- Use GraphQL for flexible API queries from web dashboard
- Redis alternative (KeyDB/Dragonfly/Valkey) for real-time data caching
- JWT-based authentication with refresh token rotation
- CloudFront CDN for static asset delivery
- Implement circuit breakers for service resilience
- Use structured logging for debugging production issues
- Horizontal scaling strategy for handling growth
- Database connection pooling for efficiency
- API rate limiting to prevent abuse
- Implement feature flags for gradual rollouts
