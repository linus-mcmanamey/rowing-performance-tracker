

## Data Migration Strategy

### iOS 15-16 Compatibility (Core Data Fallback)
```swift
// Conditional model container based on iOS version
@available(iOS 17, *)
func createSwiftDataContainer() -> ModelContainer {
    try! ModelContainer(for: Athlete.self, RowingSession.self, PerformanceMetric.self)
}

@available(iOS 15, *)
func createCoreDataContainer() -> NSPersistentContainer {
    // Core Data container for older devices
    let container = NSPersistentContainer(name: "RowingData")
    container.loadPersistentStores { _, _ in }
    return container
}

// Version detection and container selection
struct DataManager {
    static var shared: DataManager = {
        if #available(iOS 17, *) {
            return DataManager(swiftDataContainer: createSwiftDataContainer())
        } else {
            return DataManager(coreDataContainer: createCoreDataContainer())
        }
    }()
}
```

### CloudKit Setup Requirements
1. **Xcode Configuration**:
   - Enable CloudKit capability
   - Configure CloudKit container
   - Set up CloudKit schema

2. **Entitlements**:
   ```xml
   <key>com.apple.developer.icloud-container-identifiers</key>
   <array>
       <string>iCloud.com.surfseer.rowing-performance-tracker</string>
   </array>
   ```

3. **Privacy**:
   - All data in user's private CloudKit database
   - Automatic Apple ID authentication
   - No server-side access to user data# Database Schema - SwiftData + CloudKit Strategy

## SwiftData Models (Primary - Local Storage)

### **Athlete SwiftData Model**
```swift
import SwiftData
import Foundation

@Model
class Athlete {
    @Attribute(.unique) var id: UUID
    var name: String
    var email: String // CloudKit provides via Apple ID
    var teamID: UUID?
    var profileImageData: Data? // Local storage
    var preferredBoat: BoatType?
    var weight: Double? // kg
    var height: Double? // cm
    var userRole: UserRole // Athlete, Coach, Admin
    var createdAt: Date
    var modifiedAt: Date
    var isActive: Bool
    
    // Relationships
    @Relationship(deleteRule: .cascade) var sessions: [RowingSession] = []
    
    init(name: String, email: String, userRole: UserRole = .athlete) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.userRole = userRole
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.isActive = true
    }
}

enum UserRole: String, Codable, CaseIterable {
    case athlete = "athlete"
    case coach = "coach"
    case admin = "admin"
}

enum BoatType: String, Codable, CaseIterable {
    case single = "Single"
    case double = "Double"
    case four = "Four"
    case eight = "Eight"
}
```

### **RowingSession SwiftData Model**
```swift
@Model
class RowingSession {
    @Attribute(.unique) var id: UUID
    var athleteID: UUID // Foreign key to Athlete
    var teamID: UUID?
    var pm5DeviceID: String
    var sessionType: SessionType
    var startTime: Date
    var endTime: Date?
    var totalDistance: Double // meters
    var totalTime: Double // seconds
    var averagePace: Double // seconds per 500m
    var averageStrokeRate: Double // SPM
    var averagePower: Double // watts
    var maxPower: Double // peak watts
    var dragFactor: Double
    var isComplete: Bool
    var createdAt: Date
    var modifiedAt: Date
    
    // Relationships
    @Relationship var athlete: Athlete?
    @Relationship(deleteRule: .cascade) var metrics: [PerformanceMetric] = []
    
    init(athleteID: UUID, pm5DeviceID: String, sessionType: SessionType = .training) {
        self.id = UUID()
        self.athleteID = athleteID
        self.pm5DeviceID = pm5DeviceID
        self.sessionType = sessionType
        self.startTime = Date()
        self.totalDistance = 0
        self.totalTime = 0
        self.averagePace = 0
        self.averageStrokeRate = 0
        self.averagePower = 0
        self.maxPower = 0
        self.dragFactor = 0
        self.isComplete = false
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}

enum SessionType: String, Codable, CaseIterable {
    case training = "Training"
    case test = "Test"
    case race = "Race"
}
```

### **PerformanceMetric SwiftData Model**
```swift
@Model
class PerformanceMetric {
    @Attribute(.unique) var id: UUID
    var sessionID: UUID // Foreign key to RowingSession
    var timestamp: Date
    var distance: Double // cumulative meters
    var pace: Double // current 500m pace in seconds
    var strokeRate: Int // current SPM
    var power: Double // current watts
    var strokeCount: Int
    var heartRate: Int? // optional HR
    var strokePhase: StrokePhase
    var driveTime: Double // seconds
    var recoveryTime: Double // seconds
    var strokeLength: Double // meters
    var peakForce: Double // peak force this stroke
    var averageForce: Double // average force
    var workPerStroke: Double // joules
    
    // Relationships
    @Relationship var session: RowingSession?
    
    init(sessionID: UUID, timestamp: Date = Date()) {
        self.id = UUID()
        self.sessionID = sessionID
        self.timestamp = timestamp
        self.distance = 0
        self.pace = 0
        self.strokeRate = 0
        self.power = 0
        self.strokeCount = 0
        self.strokePhase = .catch
        self.driveTime = 0
        self.recoveryTime = 0
        self.strokeLength = 0
        self.peakForce = 0
        self.averageForce = 0
        self.workPerStroke = 0
    }
}

enum StrokePhase: String, Codable, CaseIterable {
    case catch = "catch"
    case drive = "drive"
    case finish = "finish"
    case recovery = "recovery"
}
```

## CloudKit Schema (Sync Layer)

**Note**: CloudKit automatically creates record types based on SwiftData models when configured. The following shows the CloudKit representation:

### **CloudKit Record Types**
```swift
// CloudKit automatically maps SwiftData models to record types:
// @Model class Athlete → CloudKit Record Type: "Athlete"
// @Model class RowingSession → CloudKit Record Type: "RowingSession"  
// @Model class PerformanceMetric → CloudKit Record Type: "PerformanceMetric"

// CloudKit Configuration
struct CloudKitConfig {
    static let containerIdentifier = "iCloud.com.surfseer.rowing-performance-tracker"
    static let privateDatabase = CKContainer.default().privateCloudDatabase
    static let sharedDatabase = CKContainer.default().sharedCloudDatabase
}

// Automatic sync configuration
let container = ModelContainer(
    for: Athlete.self, RowingSession.self, PerformanceMetric.self,
    configurations: ModelConfiguration(
        cloudKitDatabase: .automatic
    )
)
```

### **CloudKit Capabilities**
- **Automatic Sync**: SwiftData models sync automatically across devices
- **User Authentication**: Built-in Apple ID authentication
- **Data Privacy**: All data stored in user's private CloudKit database
- **Offline Support**: Local SwiftData cache, sync when online
- **Conflict Resolution**: CloudKit handles sync conflicts automatically
- **Shared Data**: Team data can use CloudKit shared databases

## PostgreSQL Schema (Phase 2 - Advanced Analytics Only)

**Note**: Only needed if CloudKit limitations are reached (large-scale analytics, coach dashboards)

```sql
-- Only created if advanced analytics backend is needed
-- Primary data remains in SwiftData + CloudKit

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "timescaledb";

-- Analytics aggregation tables (read-only from CloudKit)
CREATE TABLE athlete_analytics (
    athlete_id UUID PRIMARY KEY,
    cloudkit_record_name VARCHAR(255), -- CloudKit sync reference
    total_sessions INTEGER DEFAULT 0,
    total_distance BIGINT DEFAULT 0, -- meters
    total_time BIGINT DEFAULT 0, -- seconds  
    best_2k_time INTEGER, -- seconds
    best_5k_time INTEGER, -- seconds
    average_power DECIMAL(8,2),
    last_session_at TIMESTAMPTZ,
    analytics_updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Session analytics (aggregated from CloudKit data)
CREATE TABLE session_analytics (
    session_id UUID PRIMARY KEY,
    cloudkit_record_name VARCHAR(255),
    athlete_id UUID,
    session_date DATE,
    power_curve JSONB, -- Power analysis over time
    pace_zones JSONB, -- Time in different pace zones
    stroke_analysis JSONB, -- Stroke efficiency metrics
    analytics_computed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Time-series performance aggregates
CREATE TABLE performance_aggregates (
    time_bucket TIMESTAMPTZ NOT NULL,
    athlete_id UUID NOT NULL,
    avg_power DECIMAL(8,2),
    avg_stroke_rate DECIMAL(5,2),
    avg_pace DECIMAL(8,2),
    total_distance BIGINT,
    session_count INTEGER,
    PRIMARY KEY (time_bucket, athlete_id)
);

-- Convert to hypertable for time-series optimization  
SELECT create_hypertable('performance_aggregates', 'time_bucket');
```

## SwiftData Queries & Performance

### **Common Query Patterns**
```swift
// Recent sessions for an athlete
@Query(
    filter: #Predicate<RowingSession> { session in
        session.athleteID == athleteID && session.isComplete
    },
    sort: \RowingSession.startTime,
    order: .reverse
)
var recentSessions: [RowingSession]

// Performance metrics for a session
@Query(
    filter: #Predicate<PerformanceMetric> { metric in
        metric.sessionID == sessionID
    },
    sort: \PerformanceMetric.timestamp
)
var sessionMetrics: [PerformanceMetric]

// Active sessions
@Query(
    filter: #Predicate<RowingSession> { session in
        !session.isComplete && session.startTime > Calendar.current.date(byAdding: .hour, value: -6, to: Date())!
    }
)
var activeSessions: [RowingSession]
```

### **Performance Optimizations**
```swift
// Efficient data loading with relationships
let descriptor = FetchDescriptor<RowingSession>(
    predicate: #Predicate { $0.athleteID == athleteID },
    sortBy: [SortDescriptor(\RowingSession.startTime, order: .reverse)]
)
descriptor.fetchLimit = 50
descriptor.relationshipKeyPathsForPrefetching = [\RowingSession.metrics]

// Background processing for metrics calculation
Task.detached(priority: .background) {
    // Heavy calculations without blocking UI
    let aggregatedStats = await calculateSessionStats(sessionID)
    await MainActor.run {
        // Update UI on main thread
    }
}
```

### **CloudKit Sync Configuration**
```swift
// ModelContainer with CloudKit sync
let container = try ModelContainer(
    for: Athlete.self, RowingSession.self, PerformanceMetric.self,
    configurations: ModelConfiguration(
        cloudKitDatabase: .automatic
    )
)

// Handle sync conflicts
struct CloudKitSyncMonitor {
    static func handleSyncError(_ error: Error) {
        if let ckError = error as? CKError {
            switch ckError.code {
            case .partialFailure:
                // Handle individual record failures
                break
            case .quotaExceeded:
                // Handle CloudKit quota issues
                break
            default:
                break
            }
        }
    }
}
```
