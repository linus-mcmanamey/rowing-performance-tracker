//
//  PM5DataModels.swift
//  d_n_w
//
//  PM5 Data Models and Structures
//

import Foundation

// MARK: - General Status (0x0031) - 19 bytes
struct GeneralStatus {
    let elapsedTime: TimeInterval  // seconds (from 0.01s LSB)
    let distance: Double           // meters (from 0.1m LSB)
    let workoutType: WorkoutType
    let intervalType: IntervalType
    let workoutState: WorkoutState
    let rowingState: RowingState
    let strokeState: StrokeState
    let totalWorkDistance: Double  // meters (from 1m LSB)
    let workoutDuration: TimeInterval?  // seconds (3 bytes, 0.01s LSB)
    let workoutDurationType: UInt8?
    let dragFactor: UInt8?
}

// MARK: - Additional Status 1 (0x0032) - 17 bytes
struct AdditionalStatus1 {
    let elapsedTime: TimeInterval  // seconds (from 0.01s LSB)
    let speed: Double              // m/s (from 0.001m/s LSB)
    let strokeRate: UInt8          // strokes/min
    let heartRate: UInt8           // bpm (255 = invalid)
    let currentPace: TimeInterval  // seconds/500m (from 0.01s LSB)
    let averagePace: TimeInterval  // seconds/500m (from 0.01s LSB)
    let restDistance: UInt16       // meters
    let restTime: TimeInterval     // seconds (from 0.01s LSB)
    let ergMachineType: ErgMachineType
}

// MARK: - Additional Status 2 (0x0033) - 20 bytes
struct AdditionalStatus2 {
    let elapsedTime: TimeInterval  // seconds (from 0.01s LSB)
    let intervalCount: UInt8
    let averagePower: UInt16       // watts
    let totalCalories: UInt16      // calories
    let splitIntervalAvgPace: TimeInterval  // seconds/500m (from 0.01s LSB)
    let splitIntervalAvgPower: UInt16      // watts
    let splitIntervalAvgCalories: UInt16   // cal/hr
    let lastSplitTime: TimeInterval        // seconds (from 0.1s LSB)
    let lastSplitDistance: Double          // meters (from 1m LSB)
}

// MARK: - Stroke Data (0x0035) - 20 bytes
struct StrokeData {
    let elapsedTime: TimeInterval  // seconds (from 0.01s LSB)
    let distance: Double           // meters (from 0.1m LSB)
    let driveLength: Double        // meters (0.01m resolution, max 2.55m)
    let driveTime: TimeInterval    // seconds (0.01s resolution, max 2.55s)
    let recoveryTime: TimeInterval // seconds (0.01s resolution, max 655.35s)
    let strokeDistance: Double     // meters (0.01m resolution, max 655.35m)
    let peakDriveForce: Double     // lbs (0.1 lbs resolution)
    let averageDriveForce: Double  // lbs (0.1 lbs resolution)
    let workPerStroke: Double      // Joules (0.1 J resolution)
    let strokeCount: UInt16
}

// MARK: - Additional Stroke Data (0x0036) - 15 bytes
struct AdditionalStrokeData {
    let elapsedTime: TimeInterval  // seconds (from 0.01s LSB)
    let strokePower: UInt16        // watts
    let strokeCalories: UInt16     // cal/hr
    let strokeCount: UInt16
    let projectedWorkTime: TimeInterval     // seconds
    let projectedWorkDistance: Double       // meters
}

// MARK: - Split/Interval Data (0x0037) - 18 bytes
struct SplitIntervalData {
    let elapsedTime: TimeInterval      // seconds (from 0.01s LSB)
    let distance: Double               // meters (from 0.1m LSB)
    let splitIntervalTime: TimeInterval    // seconds (from 0.1s LSB)
    let splitIntervalDistance: Double      // meters (from 1m LSB)
    let intervalRestTime: TimeInterval     // seconds (from 1s LSB)
    let intervalRestDistance: Double       // meters (from 1m LSB)
    let splitIntervalType: UInt8
    let splitIntervalNumber: UInt8
}

// MARK: - End of Workout Summary (0x0039) - 20 bytes
struct EndOfWorkoutSummary {
    let logEntryDate: Date
    let logEntryTime: TimeInterval
    let elapsedTime: TimeInterval  // seconds (from 0.01s LSB)
    let distance: Double           // meters (from 0.1m LSB)
    let averageStrokeRate: UInt8
    let endingHeartRate: UInt8
    let averageHeartRate: UInt8
    let minHeartRate: UInt8
    let maxHeartRate: UInt8
    let dragFactorAverage: UInt8
    let recoveryHeartRate: UInt8
    let workoutType: WorkoutType
    let averagePace: TimeInterval  // seconds/500m (from 0.1s LSB)
}

// MARK: - Heart Rate Belt Info (0x003B) - 6 bytes
struct HeartRateBeltInfo {
    let manufacturerId: UInt8
    let deviceType: UInt8
    let beltId: UInt32
}

// MARK: - Device Information
struct PM5DeviceInfo {
    let modelNumber: String
    let serialNumber: String
    let hardwareRevision: String
    let firmwareRevision: String
    let manufacturer: String
    let ergMachineType: ErgMachineType
    let attMTU: UInt16
    let llDLE: UInt16
}

// MARK: - Combined Rowing Data
struct PM5RowingData {
    var generalStatus: GeneralStatus?
    var additionalStatus1: AdditionalStatus1?
    var additionalStatus2: AdditionalStatus2?
    var strokeData: StrokeData?
    var additionalStrokeData: AdditionalStrokeData?
    var splitIntervalData: SplitIntervalData?
    var heartRateBeltInfo: HeartRateBeltInfo?
    var lastUpdate: Date = Date()
}

// MARK: - Utility Extensions
extension PM5RowingData {
    // Computed properties for common metrics
    var currentSpeed: Double? {
        return additionalStatus1?.speed
    }
    
    var currentPace: TimeInterval? {
        return additionalStatus1?.currentPace
    }
    
    var strokeRate: UInt8? {
        return additionalStatus1?.strokeRate
    }
    
    var heartRate: UInt8? {
        guard let hr = additionalStatus1?.heartRate,
              hr != PM5Constants.invalidHeartRate else {
            return nil
        }
        return hr
    }
    
    var distance: Double? {
        return generalStatus?.distance
    }
    
    var elapsedTime: TimeInterval? {
        return generalStatus?.elapsedTime
    }
    
    var calories: UInt16? {
        return additionalStatus2?.totalCalories
    }
    
    var averagePower: UInt16? {
        return additionalStatus2?.averagePower
    }
}