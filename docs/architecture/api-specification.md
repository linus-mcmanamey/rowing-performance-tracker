# API Specification

## CloudKit Native APIs (Primary - MVP)
CloudKit provides automatic REST APIs for all record types. The iOS app uses CloudKit framework for direct access:

```swift
// Automatic APIs provided by CloudKit
CKDatabase.save(record) // Create/Update
CKDatabase.fetch(recordID) // Read
CKDatabase.delete(recordID) // Delete
CKQueryOperation // Query with filters
CKQuerySubscription // Real-time updates
```

## Backend REST APIs (Phase 2)

### Authentication
- `POST /api/auth/login` - Authenticate user
- `POST /api/auth/refresh` - Refresh JWT token
- `POST /api/auth/logout` - Invalidate token

### Sessions
- `GET /api/sessions` - List sessions with filtering
- `GET /api/sessions/:id` - Get session details
- `POST /api/sessions` - Create new session
- `PUT /api/sessions/:id` - Update session
- `DELETE /api/sessions/:id` - Delete session

### Teams
- `GET /api/teams/:id` - Get team info
- `GET /api/teams/:id/athletes` - List team athletes
- `GET /api/teams/:id/sessions` - Team sessions

### Export
- `GET /api/export/csv` - Export data as CSV
- `GET /api/export/json` - Export data as JSON

## WebSocket API (Phase 2)

### Connection
```typescript
// WebSocket endpoint
ws://server/ws/live/:sessionId

// Message types
interface MetricsUpdate {
  type: 'metrics';
  sessionId: string;
  athleteId: string;
  metrics: PerformanceMetric;
}

interface SessionStatus {
  type: 'status';
  sessionId: string;
  status: 'started' | 'paused' | 'completed';
}
```
