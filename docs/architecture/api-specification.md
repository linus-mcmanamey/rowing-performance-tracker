

## API Architecture Comparison

### Current MVP (SwiftData + CloudKit)
```
iOS App ←→ SwiftData (Local) ←→ CloudKit (Sync) ←→ Other Devices
   ↓
PM5 Device (Bluetooth)
```

**Benefits:**
- ✅ Zero server maintenance
- ✅ Automatic user authentication 
- ✅ Native iOS performance
- ✅ Offline-first operation
- ✅ Cross-device sync
- ✅ Enterprise-grade security

### Future Enhanced (Phase 2)
```
iOS App ←→ SwiftData ←→ CloudKit ←→ Analytics Backend ←→ Coach Dashboard
   ↓                      ↓              ↓
PM5 Device          Multi-Device    Advanced Reports
```

**Additional Capabilities:**
- 📊 Advanced analytics and reporting
- 🖥️ Cross-platform coach dashboard
- 📈 Large-scale data aggregation
- 👥 Team management features
- 🔄 Real-time coaching tools

## Implementation Guidelines

### **MVP Implementation (Phase 1)**
1. **Focus on SwiftData models** - Complete local functionality first
2. **Enable CloudKit sync** - Add CloudKit configuration to SwiftData
3. **Handle offline scenarios** - Ensure app works without internet
4. **Monitor sync status** - Optional UI feedback for sync operations
5. **Test multi-device** - Verify data syncs across user's devices

### **Backend Migration (Phase 2)** 
1. **Identify limitations** - Determine what CloudKit cannot provide
2. **Read-only integration** - Backend reads from CloudKit where possible
3. **Preserve offline-first** - Maintain primary SwiftData + CloudKit flow
4. **Add enhanced features** - Analytics, coaching tools, web dashboards
5. **Gradual migration** - Move specific features only when necessary# API Specification - SwiftData + CloudKit Strategy

## SwiftData + CloudKit Native APIs (Primary - MVP)

The iOS app uses SwiftData for local data operations with automatic CloudKit synchronization. No custom REST APIs needed for MVP.

### **SwiftData Local Operations**
```swift
// SwiftData provides type-safe, Swift-native data operations

// Create new athlete
let athlete = Athlete(name: "John Doe", email: "john@example.com")
modelContext.insert(athlete)
try await modelContext.save() // Automatically syncs to CloudKit

// Query recent sessions
@Query(
    filter: #Predicate<RowingSession> { $0.isComplete },
    sort: \RowingSession.startTime,
    order: .reverse
) var recentSessions: [RowingSession]

// Update session
session.isComplete = true
session.endTime = Date()
try await modelContext.save() // Automatic CloudKit sync

// Delete performance metrics
modelContext.delete(metric)
try await modelContext.save()
```

### **CloudKit Automatic Operations**
```swift
// CloudKit operations happen automatically with SwiftData
// No manual CloudKit API calls needed in app code

// Authentication - Automatic with Apple ID
let accountStatus = try await CKContainer.default().accountStatus()

// Sync status monitoring (optional)
let container = ModelContainer(
    for: Athlete.self, RowingSession.self, PerformanceMetric.self,
    configurations: ModelConfiguration(
        cloudKitDatabase: .automatic
    )
)

// Handle sync errors if needed
NotificationCenter.default.addObserver(
    forName: .NSPersistentCloudKitContainerEventChangedNotification,
    object: nil,
    queue: .main
) { notification in
    // Handle sync events
}
```

## CloudKit User Authentication (Automatic)

### **Apple ID Integration**
```swift
// No login screens needed - CloudKit uses Apple ID automatically
struct AuthenticationManager {
    static func checkCloudKitStatus() async throws -> CKAccountStatus {
        return try await CKContainer.default().accountStatus()
    }
    
    static func requestCloudKitPermissions() async throws {
        let status = try await checkCloudKitStatus()
        switch status {
        case .available:
            // User is signed in to iCloud - ready to use CloudKit
            break
        case .noAccount:
            // User needs to sign in to iCloud in Settings
            throw CloudKitError.noICloudAccount
        case .restricted, .couldNotDetermine:
            throw CloudKitError.iCloudUnavailable
        @unknown default:
            throw CloudKitError.unknown
        }
    }
    
    static func getCurrentUser() async throws -> CKRecord.ID {
        return try await CKContainer.default().userRecordID()
    }
}

enum CloudKitError: LocalizedError {
    case noICloudAccount
    case iCloudUnavailable
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .noICloudAccount:
            return "Please sign in to iCloud in Settings to use this app"
        case .iCloudUnavailable:
            return "iCloud is not available on this device"
        case .unknown:
            return "Unknown iCloud error"
        }
    }
}
```

## Data Export (Local Operations)

### **SwiftData Export Functions**
```swift
// Export operations work with local SwiftData
struct DataExporter {
    static func exportSessionsToCSV(for athlete: Athlete) throws -> URL {
        let sessions = athlete.sessions.sorted { $0.startTime > $1.startTime }
        
        var csvContent = "Date,Distance,Time,Pace,Power\n"
        for session in sessions {
            csvContent += "\(session.startTime),\(session.totalDistance),\(session.totalTime),\(session.averagePace),\(session.averagePower)\n"
        }
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("sessions.csv")
        try csvContent.write(to: tempURL, atomically: true, encoding: .utf8)
        return tempURL
    }
    
    static func exportSessionsToJSON(for athlete: Athlete) throws -> Data {
        let sessions = athlete.sessions.map { session in
            SessionExport(
                id: session.id,
                startTime: session.startTime,
                totalDistance: session.totalDistance,
                totalTime: session.totalTime,
                averagePace: session.averagePace,
                averagePower: session.averagePower,
                metrics: session.metrics.map { metric in
                    MetricExport(timestamp: metric.timestamp, power: metric.power, strokeRate: metric.strokeRate)
                }
            )
        }
        
        return try JSONEncoder().encode(sessions)
    }
}

struct SessionExport: Codable {
    let id: UUID
    let startTime: Date
    let totalDistance: Double
    let totalTime: Double
    let averagePace: Double
    let averagePower: Double
    let metrics: [MetricExport]
}

struct MetricExport: Codable {
    let timestamp: Date
    let power: Double
    let strokeRate: Int
}
```

## Real-Time Data Updates (Local + CloudKit)

### **SwiftData + Combine for Reactive Updates**
```swift
// Real-time updates within the app using Combine + SwiftData
class SessionManager: ObservableObject {
    @Published var currentSession: RowingSession?
    @Published var liveMetrics: PerformanceMetric?
    
    private let modelContext: ModelContext
    private var metricsTimer: Timer?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func startSession(for athleteID: UUID, deviceID: String) {
        let session = RowingSession(athleteID: athleteID, pm5DeviceID: deviceID)
        modelContext.insert(session)
        
        do {
            try modelContext.save() // Automatically syncs to CloudKit
            self.currentSession = session
            startMetricsCollection()
        } catch {
            // Handle error
        }
    }
    
    private func startMetricsCollection() {
        metricsTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // Collect metrics from PM5 device
            if let session = self.currentSession,
               let newMetric = self.collectMetricsFromPM5() {
                
                newMetric.sessionID = session.id
                self.modelContext.insert(newMetric)
                
                // Update published property for UI
                self.liveMetrics = newMetric
                
                // Save to SwiftData + CloudKit
                try? self.modelContext.save()
            }
        }
    }
    
    private func collectMetricsFromPM5() -> PerformanceMetric? {
        // PM5 BLE communication logic here
        return nil // Placeholder
    }
}
```

### **CloudKit Multi-Device Sync**
```swift
// CloudKit automatically syncs data across user's devices
// No manual sync code needed - happens automatically

// Optional: Monitor sync status
class CloudKitSyncStatus: ObservableObject {
    @Published var isSyncing = false
    @Published var lastSyncError: Error?
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .NSPersistentCloudKitContainerEventChangedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleSyncEvent(notification)
        }
    }
    
    private func handleSyncEvent(_ notification: Notification) {
        // Handle CloudKit sync events
        // Update UI to show sync status
    }
}
```

## Phase 2: Optional Backend APIs (Only if CloudKit limitations reached)

### **Advanced Analytics REST API** 
```typescript
// Only needed for features beyond CloudKit capabilities

// Advanced analytics that require server-side processing
GET /api/analytics/athlete/:id/performance-trends
GET /api/analytics/team/:id/leaderboard
POST /api/analytics/compare-sessions

// Coach dashboard features
GET /api/coaching/team/:id/insights
POST /api/coaching/workout-recommendations

// Large-scale data aggregation
GET /api/reports/team-performance/:timeframe
POST /api/exports/bulk-data
```

### **Migration Strategy**
When backend becomes necessary:
1. **Keep SwiftData + CloudKit as primary storage**
2. **Add read-only backend sync for analytics** 
3. **Backend pulls data from CloudKit (where possible)**
4. **Maintain offline-first architecture**
