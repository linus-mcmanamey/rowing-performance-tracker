//
//  PM5DataParser.swift
//  d_n_w
//
//  PM5 BLE Data Parsing
//

import Foundation

class PM5DataParser {
    // MARK: - Multi-byte Value Parsing
    static func parseUInt16(_ data: Data, offset: Int = 0) -> UInt16 {
        guard offset + 1 < data.count else { return 0 }
        return UInt16(data[offset]) | (UInt16(data[offset + 1]) << 8)
    }
    
    static func parseUInt24(_ data: Data, offset: Int = 0) -> UInt32 {
        guard offset + 2 < data.count else { return 0 }
        return UInt32(data[offset]) | 
               (UInt32(data[offset + 1]) << 8) | 
               (UInt32(data[offset + 2]) << 16)
    }
    
    static func parseUInt32(_ data: Data, offset: Int = 0) -> UInt32 {
        guard offset + 3 < data.count else { return 0 }
        return UInt32(data[offset]) | 
               (UInt32(data[offset + 1]) << 8) | 
               (UInt32(data[offset + 2]) << 16) | 
               (UInt32(data[offset + 3]) << 24)
    }
    
    // MARK: - General Status Parsing (0x0031)
    static func parseGeneralStatus(_ data: Data) -> GeneralStatus? {
        guard data.count >= 19 else { return nil }
        
        let elapsedTime = TimeInterval(parseUInt24(data, offset: 0)) / 100.0
        let distance = Double(parseUInt24(data, offset: 3)) / 10.0
        let workoutType = WorkoutType(rawValue: data[6]) ?? .justRowNoSplits
        let intervalType = IntervalType(rawValue: data[7]) ?? .none
        let workoutState = WorkoutState(rawValue: data[8]) ?? .waitToBegin
        let rowingState = RowingState(rawValue: data[9]) ?? .inactive
        let strokeState = StrokeState(rawValue: data[10]) ?? .waitingForWheelToReachMinSpeed
        let totalWorkDistance = Double(parseUInt24(data, offset: 11))
        
        var workoutDuration: TimeInterval?
        var workoutDurationType: UInt8?
        var dragFactor: UInt8?
        
        if data.count >= 17 {
            workoutDuration = TimeInterval(parseUInt24(data, offset: 14)) / 100.0
            workoutDurationType = data[17]
        }
        
        if data.count >= 19 {
            dragFactor = data[18]
        }
        
        return GeneralStatus(
            elapsedTime: elapsedTime,
            distance: distance,
            workoutType: workoutType,
            intervalType: intervalType,
            workoutState: workoutState,
            rowingState: rowingState,
            strokeState: strokeState,
            totalWorkDistance: totalWorkDistance,
            workoutDuration: workoutDuration,
            workoutDurationType: workoutDurationType,
            dragFactor: dragFactor
        )
    }
    
    // MARK: - Additional Status 1 Parsing (0x0032)
    static func parseAdditionalStatus1(_ data: Data) -> AdditionalStatus1? {
        guard data.count >= 17 else { return nil }
        
        let elapsedTime = TimeInterval(parseUInt24(data, offset: 0)) / 100.0
        let speed = Double(parseUInt16(data, offset: 3)) / 1000.0
        let strokeRate = data[5]
        let heartRate = data[6]
        let currentPace = TimeInterval(parseUInt16(data, offset: 7)) / 100.0
        let averagePace = TimeInterval(parseUInt16(data, offset: 9)) / 100.0
        let restDistance = parseUInt16(data, offset: 11)
        let restTime = TimeInterval(parseUInt24(data, offset: 13)) / 100.0
        let ergMachineType = ErgMachineType(rawValue: data[16]) ?? .staticD
        
        return AdditionalStatus1(
            elapsedTime: elapsedTime,
            speed: speed,
            strokeRate: strokeRate,
            heartRate: heartRate,
            currentPace: currentPace,
            averagePace: averagePace,
            restDistance: restDistance,
            restTime: restTime,
            ergMachineType: ergMachineType
        )
    }
    
    // MARK: - Additional Status 2 Parsing (0x0033)
    static func parseAdditionalStatus2(_ data: Data) -> AdditionalStatus2? {
        guard data.count >= 20 else { return nil }
        
        let elapsedTime = TimeInterval(parseUInt24(data, offset: 0)) / 100.0
        let intervalCount = data[3]
        let averagePower = parseUInt16(data, offset: 4)
        let totalCalories = parseUInt16(data, offset: 6)
        let splitIntervalAvgPace = TimeInterval(parseUInt16(data, offset: 8)) / 100.0
        let splitIntervalAvgPower = parseUInt16(data, offset: 10)
        let splitIntervalAvgCalories = parseUInt16(data, offset: 12)
        let lastSplitTime = TimeInterval(parseUInt24(data, offset: 14)) / 10.0
        let lastSplitDistance = Double(parseUInt24(data, offset: 17))
        
        return AdditionalStatus2(
            elapsedTime: elapsedTime,
            intervalCount: intervalCount,
            averagePower: averagePower,
            totalCalories: totalCalories,
            splitIntervalAvgPace: splitIntervalAvgPace,
            splitIntervalAvgPower: splitIntervalAvgPower,
            splitIntervalAvgCalories: splitIntervalAvgCalories,
            lastSplitTime: lastSplitTime,
            lastSplitDistance: lastSplitDistance
        )
    }
    
    // MARK: - Stroke Data Parsing (0x0035)
    static func parseStrokeData(_ data: Data) -> StrokeData? {
        guard data.count >= 20 else { return nil }
        
        let elapsedTime = TimeInterval(parseUInt24(data, offset: 0)) / 100.0
        let distance = Double(parseUInt24(data, offset: 3)) / 10.0
        let driveLength = Double(data[6]) / 100.0
        let driveTime = TimeInterval(data[7]) / 100.0
        let recoveryTime = TimeInterval(parseUInt16(data, offset: 8)) / 100.0
        let strokeDistance = Double(parseUInt16(data, offset: 10)) / 100.0
        let peakDriveForce = Double(parseUInt16(data, offset: 12)) / 10.0
        let averageDriveForce = Double(parseUInt16(data, offset: 14)) / 10.0
        let workPerStroke = Double(parseUInt16(data, offset: 16)) / 10.0
        let strokeCount = parseUInt16(data, offset: 18)
        
        return StrokeData(
            elapsedTime: elapsedTime,
            distance: distance,
            driveLength: driveLength,
            driveTime: driveTime,
            recoveryTime: recoveryTime,
            strokeDistance: strokeDistance,
            peakDriveForce: peakDriveForce,
            averageDriveForce: averageDriveForce,
            workPerStroke: workPerStroke,
            strokeCount: strokeCount
        )
    }
    
    // MARK: - Additional Stroke Data Parsing (0x0036)
    static func parseAdditionalStrokeData(_ data: Data) -> AdditionalStrokeData? {
        guard data.count >= 15 else { return nil }
        
        let elapsedTime = TimeInterval(parseUInt24(data, offset: 0)) / 100.0
        let strokePower = parseUInt16(data, offset: 3)
        let strokeCalories = parseUInt16(data, offset: 5)
        let strokeCount = parseUInt16(data, offset: 7)
        let projectedWorkTime = TimeInterval(parseUInt24(data, offset: 9))
        let projectedWorkDistance = Double(parseUInt24(data, offset: 12))
        
        return AdditionalStrokeData(
            elapsedTime: elapsedTime,
            strokePower: strokePower,
            strokeCalories: strokeCalories,
            strokeCount: strokeCount,
            projectedWorkTime: projectedWorkTime,
            projectedWorkDistance: projectedWorkDistance
        )
    }
    
    // MARK: - Split/Interval Data Parsing (0x0037)
    static func parseSplitIntervalData(_ data: Data) -> SplitIntervalData? {
        guard data.count >= 18 else { return nil }
        
        let elapsedTime = TimeInterval(parseUInt24(data, offset: 0)) / 100.0
        let distance = Double(parseUInt24(data, offset: 3)) / 10.0
        let splitIntervalTime = TimeInterval(parseUInt24(data, offset: 6)) / 10.0
        let splitIntervalDistance = Double(parseUInt24(data, offset: 9))
        let intervalRestTime = TimeInterval(parseUInt16(data, offset: 12))
        let intervalRestDistance = Double(parseUInt16(data, offset: 14))
        let splitIntervalType = data[16]
        let splitIntervalNumber = data[17]
        
        return SplitIntervalData(
            elapsedTime: elapsedTime,
            distance: distance,
            splitIntervalTime: splitIntervalTime,
            splitIntervalDistance: splitIntervalDistance,
            intervalRestTime: intervalRestTime,
            intervalRestDistance: intervalRestDistance,
            splitIntervalType: splitIntervalType,
            splitIntervalNumber: splitIntervalNumber
        )
    }
    
    // MARK: - End of Workout Summary Parsing (0x0039)
    static func parseEndOfWorkoutSummary(_ data: Data) -> EndOfWorkoutSummary? {
        guard data.count >= 20 else { return nil }
        
        // Parse date and time
        let dateValue = parseUInt16(data, offset: 0)
        let timeValue = parseUInt16(data, offset: 2)
        
        // Convert PM5 date/time format to Date
        // Note: This is a simplified conversion - adjust based on actual PM5 format
        let date = Date() // Placeholder - implement actual conversion
        
        let elapsedTime = TimeInterval(parseUInt24(data, offset: 4)) / 100.0
        let distance = Double(parseUInt24(data, offset: 7)) / 10.0
        let averageStrokeRate = data[10]
        let endingHeartRate = data[11]
        let averageHeartRate = data[12]
        let minHeartRate = data[13]
        let maxHeartRate = data[14]
        let dragFactorAverage = data[15]
        let recoveryHeartRate = data[16]
        let workoutType = WorkoutType(rawValue: data[17]) ?? .justRowNoSplits
        let averagePace = TimeInterval(parseUInt16(data, offset: 18)) / 10.0
        
        return EndOfWorkoutSummary(
            logEntryDate: date,
            logEntryTime: TimeInterval(timeValue),
            elapsedTime: elapsedTime,
            distance: distance,
            averageStrokeRate: averageStrokeRate,
            endingHeartRate: endingHeartRate,
            averageHeartRate: averageHeartRate,
            minHeartRate: minHeartRate,
            maxHeartRate: maxHeartRate,
            dragFactorAverage: dragFactorAverage,
            recoveryHeartRate: recoveryHeartRate,
            workoutType: workoutType,
            averagePace: averagePace
        )
    }
    
    // MARK: - Heart Rate Belt Info Parsing (0x003B)
    static func parseHeartRateBeltInfo(_ data: Data) -> HeartRateBeltInfo? {
        guard data.count >= 6 else { return nil }
        
        let manufacturerId = data[0]
        let deviceType = data[1]
        let beltId = parseUInt32(data, offset: 2)
        
        return HeartRateBeltInfo(
            manufacturerId: manufacturerId,
            deviceType: deviceType,
            beltId: beltId
        )
    }
    
    // MARK: - Multiplexed Information Parsing (0x0080)
    static func parseMultiplexedInfo(_ data: Data) -> (identifier: UInt8, data: Data)? {
        guard data.count >= 2 else { return nil }
        
        let identifier = data[0]
        let characteristicData = data.subdata(in: 1..<data.count)
        
        return (identifier, characteristicData)
    }
}

// MARK: - Conversion Utilities
extension PM5DataParser {
    // Convert watts to pace (seconds per 500m)
    static func wattsToPace(_ watts: Double) -> TimeInterval {
        guard watts > 0 else { return 0 }
        return pow(2.8 / watts, 1.0 / 3.0) * 500.0
    }
    
    // Convert pace to watts
    static func paceToWatts(_ pace: TimeInterval) -> Double {
        guard pace > 0 else { return 0 }
        let pacePerMeter = pace / 500.0
        return 2.8 / pow(pacePerMeter, 3.0)
    }
    
    // Convert calories/hr to pace
    static func caloriesToPace(_ calories: Double) -> TimeInterval {
        let watts = (calories - 300.0) / (4.0 * 0.8604)
        return wattsToPace(watts)
    }
    
    // Convert pace to speed (m/s)
    static func paceToSpeed(_ pace: TimeInterval) -> Double {
        guard pace > 0 else { return 0 }
        return 500.0 / pace
    }
}
