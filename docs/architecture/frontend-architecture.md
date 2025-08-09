# Frontend Architecture

## iOS App Architecture (Supporting iOS 15+ and Older Devices)

### Device Support Strategy
- **Minimum iOS Version:** iOS 15.0 (iPhone 6S and newer)
- **Target Audience:** Students with 7-8 year old hand-me-down devices
- **Performance Tiers:** Automatic feature detection and graceful degradation

### Component Organization
```
d_n_w/
├── d_n_w/
│   ├── App/
│   │   ├── d_n_wApp.swift
│   │   └── AppDelegate.swift
│   ├── Core/
│   │   ├── PM5/                    # Existing BLE implementation
│   │   │   ├── PM5Controller.swift
│   │   │   ├── CSAFEProtocol.swift
│   │   │   ├── PM5DataModels.swift
│   │   │   ├── PM5DataParser.swift
│   │   │   └── PM5TestView.swift
│   │   ├── Data/
│   │   │   ├── CloudKitManager.swift
│   │   │   ├── BackendAPIClient.swift
│   │   │   └── DataSyncCoordinator.swift
│   │   ├── DeviceCapabilities/
│   │   │   ├── DeviceCapabilities.swift
│   │   │   └── PerformanceOptimizer.swift
│   │   └── Models/
│   │       ├── Athlete.swift
│   │       └── RowingSession.swift
│   ├── Features/
│   │   ├── Session/
│   │   │   ├── SessionView.swift
│   │   │   ├── SessionViewModel.swift
│   │   │   └── Components/
│   │   │       ├── MetricsGrid.swift
│   │   │       ├── PowerCurveChart.swift (Custom iOS 15)
│   │   │       ├── SimplifiedMetrics.swift (Fallback)
│   │   │       └── StrokeRateVisualizer.swift
│   │   ├── History/
│   │   └── Settings/
│   └── Resources/
```

### iOS 15 Compatible SwiftUI Implementation
```swift
// iOS 15 compatible navigation
struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    
    var body: some View {
        NavigationView {  // iOS 15 compatible
            HomeView()
                .navigationTitle("Rowing Tracker")
        }
        .navigationViewStyle(StackNavigationViewStyle())  // Consistent behavior
    }
}

// Device-aware performance visualizer
struct PerformanceVisualizer: View {
    let metrics: PM5RowingData
    @Environment(\.deviceCapabilities) var capabilities
    
    var body: some View {
        Group {
            if capabilities.supportsAdvancedGraphics {
                AdvancedVisualizationView(metrics: metrics)
            } else {
                SimplifiedMetricsView(metrics: metrics)
            }
        }
    }
}

// Custom chart implementation for iOS 15 compatibility
struct PowerCurveChart: View {
    let dataPoints: [PowerPoint]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    // Horizontal lines
                    for i in 0..<5 {
                        let y = height * CGFloat(i) / 4
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                
                // Power curve
                Path { path in
                    guard !dataPoints.isEmpty else { return }
                    
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let maxPower = dataPoints.map(\.power).max() ?? 1
                    
                    path.move(to: CGPoint(
                        x: 0,
                        y: height - (height * CGFloat(dataPoints[0].power) / CGFloat(maxPower))
                    ))
                    
                    for (index, point) in dataPoints.enumerated() {
                        let x = width * CGFloat(index) / CGFloat(dataPoints.count - 1)
                        let y = height - (height * CGFloat(point.power) / CGFloat(maxPower))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
        }
        .frame(height: 200)
    }
}
```

### Device Capability Detection
```swift
struct DeviceCapabilities {
    let supportsAdvancedGraphics: Bool
    let supportsMetal: Bool
    let supportsHaptics: Bool
    let memoryTier: MemoryTier
    let preferredUpdateRate: TimeInterval
    
    enum MemoryTier {
        case low    // < 2GB RAM
        case medium // 2-4GB RAM
        case high   // > 4GB RAM
    }
    
    init() {
        let physicalMemory = ProcessInfo.processInfo.physicalMemory
        self.memoryTier = {
            if physicalMemory < 2_000_000_000 { return .low }
            if physicalMemory < 4_000_000_000 { return .medium }
            return .high
        }()
        
        self.supportsAdvancedGraphics = memoryTier != .low
        self.supportsMetal = MTLCreateSystemDefaultDevice() != nil
        self.supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        
        // Adjust update rates based on device capability
        self.preferredUpdateRate = {
            let modelName = UIDevice.current.modelName
            if modelName.contains("iPhone6") || modelName.contains("iPhone7") {
                return 1.0  // 1 second updates
            }
            return 0.5  // 500ms updates
        }()
    }
}

// Environment key for device capabilities
struct DeviceCapabilitiesKey: EnvironmentKey {
    static let defaultValue = DeviceCapabilities()
}

extension EnvironmentValues {
    var deviceCapabilities: DeviceCapabilities {
        get { self[DeviceCapabilitiesKey.self] }
        set { self[DeviceCapabilitiesKey.self] = newValue }
    }
}
```

### Performance Optimization for Older Devices
```swift
// Memory-conscious session recording
class SessionViewModel: ObservableObject {
    @Published var currentMetrics = PM5RowingData()
    @Published var powerCurve: [PowerPoint] = []
    @Published var isRecording = false
    
    private var maxDataPoints: Int {
        let capabilities = DeviceCapabilities()
        switch capabilities.memoryTier {
        case .low:
            return 300   // 5 minutes at 1s intervals
        case .medium:
            return 600   // 10 minutes at 1s intervals
        case .high:
            return 1200  // 20 minutes at 0.5s intervals
        }
    }
    
    private var updateTimer: Timer?
    
    func startSession() {
        let capabilities = DeviceCapabilities()
        updateTimer = Timer.scheduledTimer(withTimeInterval: capabilities.preferredUpdateRate, repeats: true) { _ in
            self.updateMetrics()
        }
    }
    
    private func updateMetrics() {
        // Limit power curve data to prevent memory issues
        if powerCurve.count > maxDataPoints {
            powerCurve.removeFirst(powerCurve.count - maxDataPoints)
        }
    }
}
```

## State Management Architecture

```swift
@MainActor
class SessionViewModel: ObservableObject {
    @Published var currentMetrics = PM5RowingData()
    @Published var powerCurve: [PowerPoint] = []
    @Published var isRecording = false
    @Published var error: PM5Error?
    
    private let pm5Controller: PM5Controller
    private let cloudKitManager: CloudKitManager
    private let apiClient: BackendAPIClient
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.pm5Controller = PM5Controller.shared
        self.cloudKitManager = CloudKitManager.shared
        self.apiClient = BackendAPIClient.shared
        setupBindings()
    }
    
    private func setupBindings() {
        // Throttle updates based on device capabilities
        let capabilities = DeviceCapabilities()
        
        pm5Controller.$rowingData
            .throttle(for: .seconds(capabilities.preferredUpdateRate), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] data in
                self?.currentMetrics = data
                self?.updatePowerCurve(data.power)
            }
            .store(in: &cancellables)
    }
}
```

## Coach Dashboard Architecture (Web)

### Component Organization
```
coach-dashboard/
├── src/
│   ├── components/
│   │   ├── Dashboard/
│   │   │   ├── LiveSessionGrid.tsx
│   │   │   └── AthleteCard.tsx
│   │   └── Shared/
│   ├── hooks/
│   │   ├── useWebSocket.ts
│   │   └── useTeamData.ts
│   ├── services/
│   │   └── api.ts
│   └── App.tsx
```

### Routing Architecture

**iOS Navigation (iOS 15 compatible):**
```swift
struct ContentView: View {
    @StateObject private var router = NavigationRouter()
    
    var body: some View {
        NavigationView {
            HomeView()
                .navigationTitle("Rowing Tracker")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
```

**Web Dashboard Routing:**
```typescript
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const AppRouter = () => (
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Dashboard />} />
      <Route path="/session/:sessionId" element={<SessionDetail />} />
      <Route path="/export" element={<ExportView />} />
    </Routes>
  </BrowserRouter>
);
```
