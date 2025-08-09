# Database Schema

## CloudKit Schema (Primary - MVP)

### **Athlete Record Type**
```swift
// CloudKit Record Type: Athlete
{
  recordType: "Athlete",
  fields: {
    athleteId: String (indexed, queryable),
    name: String (searchable),
    email: String (indexed, unique),
    teamId: Reference<Team> (indexed),
    profileImage: Asset,
    preferredBoat: String,
    weight: Double,
    height: Double,
    createdAt: Date (sortable),
    modifiedAt: Date (sortable),
    isActive: Bool (indexed, default: true)
  }
}
```

### **RowingSession Record Type**
```swift
// CloudKit Record Type: RowingSession
{
  recordType: "RowingSession",
  fields: {
    sessionId: String (indexed, queryable),
    athleteId: Reference<Athlete> (indexed),
    teamId: Reference<Team> (indexed),
    pm5DeviceId: String,
    sessionType: String,
    sessionType: String,
    startTime: Date (indexed, sortable),
    endTime: Date,
    totalDistance: Double,
    totalTime: Double,
    averagePace: Double,
    averageStrokeRate: Double,
    averagePower: Double,
    maxPower: Double,
    dragFactor: Double,
    intervals: [Data],
    isComplete: Bool (indexed, default: false),
    syncStatus: String,
    createdAt: Date,
    modifiedAt: Date
  },
  indexes: [
    "byAthlete": [athleteId, startTime DESC],
    "byTeam": [teamId, startTime DESC],
    "recentSessions": [startTime DESC]
  ]
}
```

### **PerformanceMetric Record Type**
```swift
// CloudKit Record Type: PerformanceMetric
{
  recordType: "PerformanceMetric",
  fields: {
    metricId: String (indexed),
    sessionId: Reference<RowingSession> (indexed),
    timestamp: Date (indexed, sortable),
    distance: Double,
    pace: Double,
    strokeRate: Int,
    power: Double,
    strokeCount: Int,
    heartRate: Int?,
    strokePhase: String,
    driveTime: Double,
    recoveryTime: Double,
    strokeLength: Double,
    peakForce: Double,
    averageForce: Double,
    workPerStroke: Double
  },
  indexes: [
    "bySession": [sessionId, timestamp],
    "byTimestamp": [timestamp DESC]
  ]
}
```

## PostgreSQL Schema (Phase 2 - Backend)

```sql
-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "timescaledb";

-- Athletes table
CREATE TABLE athletes (
    athlete_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    team_id UUID REFERENCES teams(team_id),
    preferred_boat VARCHAR(20),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    modified_at TIMESTAMPTZ DEFAULT NOW(),
    is_active BOOLEAN DEFAULT true
);

-- Sessions table
CREATE TABLE rowing_sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    athlete_id UUID REFERENCES athletes(athlete_id),
    team_id UUID REFERENCES teams(team_id),
    pm5_device_id VARCHAR(50),
    session_type VARCHAR(20),
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ,
    total_distance DOUBLE PRECISION,
    total_time DOUBLE PRECISION,
    average_pace DOUBLE PRECISION,
    average_stroke_rate DOUBLE PRECISION,
    average_power DOUBLE PRECISION,
    max_power DOUBLE PRECISION,
    drag_factor DOUBLE PRECISION,
    intervals JSONB,
    is_complete BOOLEAN DEFAULT false,
    sync_status VARCHAR(20) DEFAULT 'pending'
);

-- Performance metrics (TimescaleDB hypertable)
CREATE TABLE performance_metrics (
    time TIMESTAMPTZ NOT NULL,
    session_id UUID NOT NULL,
    athlete_id UUID NOT NULL,
    distance DOUBLE PRECISION,
    pace DOUBLE PRECISION,
    stroke_rate INTEGER,
    power DOUBLE PRECISION,
    heart_rate INTEGER,
    stroke_phase VARCHAR(20),
    drive_time DOUBLE PRECISION,
    recovery_time DOUBLE PRECISION,
    stroke_length DOUBLE PRECISION,
    peak_force DOUBLE PRECISION,
    average_force DOUBLE PRECISION,
    work_per_stroke DOUBLE PRECISION,
    PRIMARY KEY (time, session_id)
);

-- Convert to hypertable for time-series optimization
SELECT create_hypertable('performance_metrics', 'time');

-- Indexes for query performance
CREATE INDEX idx_sessions_athlete_time ON rowing_sessions(athlete_id, start_time DESC);
CREATE INDEX idx_sessions_team_time ON rowing_sessions(team_id, start_time DESC);
CREATE INDEX idx_metrics_session ON performance_metrics(session_id, time DESC);
```

## DynamoDB Schema (Phase 2 - Real-Time Layer)

### **WebSocketConnections Table**
```typescript
{
  TableName: "WebSocketConnections",
  PartitionKey: "connectionId",
  SortKey: "sessionId",
  Attributes: {
    connectionId: string,
    sessionId: string,
    athleteId: string,
    teamId: string,
    connectionType: "athlete" | "coach",
    connectedAt: number,
    lastPingAt: number,
    clientInfo: {
      appVersion: string,
      deviceModel: string,
      osVersion: string
    }
  },
  GlobalSecondaryIndexes: [
    { name: "SessionIndex", partitionKey: "sessionId", sortKey: "connectedAt" },
    { name: "TeamIndex", partitionKey: "teamId", sortKey: "connectionType" }
  ],
  TTL: "ttl"
}
```
