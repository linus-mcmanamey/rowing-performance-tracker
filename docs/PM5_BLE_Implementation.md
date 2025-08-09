# PM5 BLE Implementation

This document describes the complete PM5 BLE communication implementation for the d_n_w iOS application.

## Overview

The implementation provides a comprehensive solution for connecting to and communicating with Concept2 PM5 rowing monitors via Bluetooth Low Energy (BLE). It includes real-time data monitoring, workout control, and CSAFE protocol support.

## Architecture

### Core Components

1. **PM5Constants.swift** - Service UUIDs, characteristic definitions, and enumerations
2. **PM5DataModels.swift** - Data structures for PM5 information
3. **PM5DataParser.swift** - Binary data parsing utilities
4. **PM5Controller.swift** - Main BLE controller class
5. **CSAFEProtocol.swift** - CSAFE command/response handling
6. **PM5TestView.swift** - SwiftUI test interface

### Key Features

- **Automatic Device Discovery**: Scans for and connects to PM5 devices
- **Real-time Data Streaming**: Receives rowing metrics at configurable intervals
- **Workout Control**: Start different workout types via CSAFE commands
- **Data Parsing**: Handles all PM5 data formats with proper byte ordering
- **Error Handling**: Comprehensive error reporting and connection management
- **SwiftUI Integration**: Observable objects for reactive UI updates

## Services and Characteristics

### Device Information Service (0x0010)
- Model Number, Serial Number, Hardware/Firmware Revision
- Manufacturer, Machine Type, MTU/DLE capabilities

### Control Service (0x0020)
- PM Receive (0x0021) - Send CSAFE commands
- PM Transmit (0x0022) - Receive CSAFE responses

### Rowing Service (0x0030)
- **General Status (0x0031)**: Time, distance, workout state, stroke state
- **Additional Status 1 (0x0032)**: Speed, stroke rate, heart rate, pace
- **Additional Status 2 (0x0033)**: Power, calories, interval data
- **Stroke Data (0x0035)**: Drive length/time, forces, work per stroke
- **Sample Rate Control (0x0034)**: Configure update frequency

## Data Models

### Primary Data Structures

```swift
struct GeneralStatus {
    let elapsedTime: TimeInterval
    let distance: Double
    let workoutType: WorkoutType
    let workoutState: WorkoutState
    // ... additional fields
}

struct PM5RowingData {
    var generalStatus: GeneralStatus?
    var additionalStatus1: AdditionalStatus1?
    var additionalStatus2: AdditionalStatus2?
    // ... computed properties for common metrics
}
```

### Data Parsing

All multi-byte values use little-endian byte ordering:
- 2-byte: `UInt16(data[0]) | (UInt16(data[1]) << 8)`
- 3-byte: `UInt32(data[0]) | (UInt32(data[1]) << 8) | (UInt32(data[2]) << 16)`
- 4-byte: Standard UInt32 little-endian

Time and distance conversions:
- Elapsed time: 0.01s LSB → TimeInterval
- Distance: 0.1m LSB → Double (meters)
- Pace: 0.01s LSB → TimeInterval (seconds per 500m)

## CSAFE Protocol

### Frame Structure
```
Standard Frame: [0xF1] [Frame Contents] [Checksum] [0xF2]
Extended Frame: [0xF0] [Dest] [Src] [Frame Contents] [Checksum] [0xF2]
```

### Byte Stuffing
- 0xF0 → 0xF3, 0x00
- 0xF1 → 0xF3, 0x01  
- 0xF2 → 0xF3, 0x02
- 0xF3 → 0xF3, 0x03

### Common Commands
- **Get Status** (0x80): Query PM5 status
- **Set Workout Type** (0x76): Configure workout parameters
- **Go to Workout Screen**: Navigate to rowing interface

## Usage Examples

### Basic Connection
```swift
@StateObject private var pm5Controller = PM5Controller()

// Start scanning
pm5Controller.startScanning()

// Connect to device
pm5Controller.connect(to: peripheral)

// Access rowing data
let distance = pm5Controller.rowingData.distance
let pace = pm5Controller.rowingData.currentPace
```

### Workout Control
```swift
// Start a just row workout
pm5Controller.startJustRowWorkout()

// Start distance workout
pm5Controller.startDistanceWorkout(meters: 2000)

// Start time workout  
pm5Controller.startTimeWorkout(minutes: 20, seconds: 0)
```

### Data Monitoring
```swift
// Configure sample rate
pm5Controller.setSampleRate(PM5Constants.sampleRate500ms)

// Observe data changes
pm5Controller.rowingData.generalStatus?.elapsedTime
pm5Controller.rowingData.additionalStatus1?.strokeRate
```

## Configuration

### Sample Rates
- 0: 1 second intervals
- 1: 500ms intervals (default)
- 2: 250ms intervals  
- 3: 100ms intervals

### Connection Parameters
- Connection interval: 30ms (optimal performance)
- MTU: Negotiate up to 512 bytes
- Timeout: 10 seconds

## Error Handling

The implementation includes comprehensive error handling:

```swift
enum PM5Error: LocalizedError {
    case bluetoothNotAvailable
    case connectionFailed
    case serviceDiscoveryFailed
    case characteristicDiscoveryFailed
    case dataParsingFailed
    case commandFailed
}
```

## Testing

The `PM5TestView` provides a complete test interface with:
- Device discovery and connection
- Real-time data display
- Workout controls
- Sample rate configuration
- Error reporting

## Best Practices

1. **Power Management**: Use appropriate sample rates to conserve battery
2. **Connection Stability**: Handle disconnections gracefully
3. **Data Validation**: Always validate parsed data ranges
4. **User Experience**: Provide clear feedback for connection states
5. **Error Recovery**: Implement retry logic for failed operations

## Integration

To integrate into your app:

1. Add all PM5 Swift files to your project
2. Ensure Bluetooth permissions in Info.plist
3. Use `PM5Controller` as an ObservableObject in SwiftUI
4. Handle connection lifecycle in your UI

The implementation is production-ready and follows iOS development best practices for BLE communication and SwiftUI integration.