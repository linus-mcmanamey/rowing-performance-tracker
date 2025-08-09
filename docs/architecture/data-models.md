# Data Models

## Athlete
**Purpose:** Represents an individual athlete user of the platform

**TypeScript Interface:**
```typescript
interface Athlete {
  athleteId: string;      // UUID
  name: string;
  email: string;
  teamId?: string;        // Reference to Team
  profileImageUrl?: string;
  preferredBoat?: 'Single' | 'Double' | 'Four' | 'Eight';
  weight?: number;        // kg
  height?: number;        // cm
  createdAt: Date;
  modifiedAt: Date;
  isActive: boolean;
}
```

**Relationships:** Belongs to Team, has many RowingSessions

## RowingSession
**Purpose:** Represents a single rowing session with comprehensive metrics

**TypeScript Interface:**
```typescript
interface RowingSession {
  sessionId: string;      // UUID
  athleteId: string;
  teamId?: string;
  pm5DeviceId: string;    // PM5 serial number
  sessionType: 'Training' | 'Test' | 'Race';
  startTime: Date;
  endTime?: Date;
  totalDistance: number;  // meters
  totalTime: number;      // seconds
  averagePace: number;    // seconds per 500m
  averageStrokeRate: number; // SPM
  averagePower: number;   // watts
  maxPower: number;       // peak watts
  dragFactor: number;
  intervals?: Interval[];
  isComplete: boolean;
  syncStatus: 'synced' | 'pending' | 'error';
}
```

**Relationships:** Belongs to Athlete, has many PerformanceMetrics

## PerformanceMetric
**Purpose:** Granular time-series data for each stroke and interval

**TypeScript Interface:**
```typescript
interface PerformanceMetric {
  metricId: string;
  sessionId: string;
  timestamp: Date;
  distance: number;       // cumulative meters
  pace: number;          // current 500m pace
  strokeRate: number;    // current SPM
  power: number;         // current watts
  strokeCount: number;
  heartRate?: number;    // optional HR
  strokePhase: 'catch' | 'drive' | 'finish' | 'recovery';
  driveTime: number;     // seconds
  recoveryTime: number;  // seconds
  strokeLength: number;  // meters
  peakForce: number;     // peak force this stroke
  averageForce: number;  // average force
  workPerStroke: number; // joules
}
```

**Relationships:** Belongs to RowingSession

## PM5Device (Existing)
**Purpose:** Represents a connected PM5 monitor

**Swift Model (Existing in codebase):**
```swift
struct PM5DeviceInfo {
    let serialNumber: String
    let hardwareVersion: String
    let firmwareVersion: String
    let manufacturer: String
}
```
