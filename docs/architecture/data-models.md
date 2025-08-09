

## Data Model Usage Patterns

### **Creating New Data**
```swift
// Create athlete (typically on first app launch)
let athlete = Athlete(name: "John Doe", email: "john@icloud.com", userRole: .athlete)
modelContext.insert(athlete)
try await modelContext.save() // Auto-sync to CloudKit

// Start new session
let session = RowingSession(athleteID: athlete.id, pm5DeviceID: "PM5-12345")
modelContext.insert(session)
try await modelContext.save()

// Add performance metrics during session
let metric = PerformanceMetric(sessionID: session.id)
metric.power = 150.0
metric.strokeRate = 24
modelContext.insert(metric)
try await modelContext.save() // Frequent saves for real-time data
```

### **Querying Data**
```swift
// Recent sessions for current athlete
@Query(
    filter: #Predicate<RowingSession> { session in
        session.athleteID == currentAthleteID && session.isComplete
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

// Active PM5 devices
@Query(
    filter: #Predicate<PM5Device> { $0.isActive },
    sort: \PM5Device.lastConnected,
    order: .reverse
)
var availableDevices: [PM5Device]
```

### **Updating Data**
```swift
// Complete a session
session.isComplete = true
session.endTime = Date()
session.totalDistance = metrics.last?.distance ?? 0
session.modifiedAt = Date()
try await modelContext.save()

// Update athlete profile
athlete.weight = 75.0
athlete.preferredBoat = .single
athlete.modifiedAt = Date()
try await modelContext.save()
```

### **Data Relationships**
```swift
// Access related data through relationships
let athleteSessions = athlete.sessions.sorted { $0.startTime > $1.startTime }
let sessionMetrics = session.metrics.sorted { $0.timestamp < $1.timestamp }

// Aggregate calculations
let totalDistance = athlete.sessions.reduce(0) { $0 + $1.totalDistance }
let averagePower = athlete.sessions.compactMap { $0.averagePower }.reduce(0, +) / Double(athlete.sessions.count)
```

## CloudKit Integration Benefits

### **Automatic Features**
- ✅ **Cross-device sync** - Data appears on all user's Apple devices
- ✅ **Offline support** - Works without internet, syncs when connected
- ✅ **Conflict resolution** - CloudKit handles data conflicts automatically
- ✅ **User authentication** - Apple ID integration, no login screens
- ✅ **Data privacy** - All data in user's private CloudKit database
- ✅ **Backup & restore** - Automatic backup to iCloud

### **Performance Characteristics**
- **Local-first** - All queries run against local SwiftData store
- **Background sync** - CloudKit syncs in background without blocking UI
- **Efficient delta sync** - Only changed data transmitted
- **Compressed transmission** - CloudKit optimizes data transfer
- **Retry logic** - Automatic retry for failed sync operations

### **Development Benefits**
- **Type safety** - SwiftData models are fully type-safe at compile time
- **Query performance** - Predicate-based queries optimized by SwiftData
- **Memory management** - Automatic memory management for large datasets
- **Migration support** - SwiftData handles schema migrations
- **Testing support** - In-memory containers for unit testing# Data Models - SwiftData + CloudKit Strategy

## Athlete
**Purpose:** Represents an individual athlete user of the platform

**SwiftData Model:**
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

**CloudKit Sync:** Automatically synced via SwiftData configuration
**Relationships:** Has many RowingSessions (cascade delete)

## RowingSession
**Purpose:** Represents a single rowing session with comprehensive metrics

**SwiftData Model:**
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

**CloudKit Sync:** Automatic via SwiftData
**Relationships:** Belongs to Athlete, has many PerformanceMetrics (cascade delete)

## PerformanceMetric
**Purpose:** Granular time-series data for each stroke and interval

**SwiftData Model:**
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

**CloudKit Sync:** Automatic via SwiftData
**Relationships:** Belongs to RowingSession

## PM5Device 
**Purpose:** Represents a connected PM5 monitor with enhanced tracking

**SwiftData Model (Enhanced):**
```swift
@Model
class PM5Device {
    @Attribute(.unique) var id: UUID
    var serialNumber: String
    var hardwareVersion: String
    var firmwareVersion: String
    var manufacturer: String
    var nickname: String? // User-friendly name
    var lastConnected: Date?
    var isActive: Bool
    var createdAt: Date
    var modifiedAt: Date
    
    // Relationships
    @Relationship var sessions: [RowingSession] = []
    
    init(serialNumber: String, hardwareVersion: String, firmwareVersion: String, manufacturer: String = "Concept2") {
        self.id = UUID()
        self.serialNumber = serialNumber
        self.hardwareVersion = hardwareVersion
        self.firmwareVersion = firmwareVersion
        self.manufacturer = manufacturer
        self.isActive = true
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}

// Legacy compatibility for existing code
struct PM5DeviceInfo {
    let serialNumber: String
    let hardwareVersion: String
    let firmwareVersion: String
    let manufacturer: String
    
    init(from device: PM5Device) {
        self.serialNumber = device.serialNumber
        self.hardwareVersion = device.hardwareVersion
        self.firmwareVersion = device.firmwareVersion
        self.manufacturer = device.manufacturer
    }
}
```

**CloudKit Sync:** User's connected devices sync across their Apple devices
**Relationships:** Has many RowingSessions
