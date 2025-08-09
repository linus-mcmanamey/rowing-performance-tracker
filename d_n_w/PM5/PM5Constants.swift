//
//  PM5Constants.swift
//  d_n_w
//
//  PM5 BLE Service and Characteristic UUIDs
//

import CoreBluetooth

// MARK: - PM5 Service UUIDs
struct PM5ServiceUUIDs {
    // Base UUID pattern: CE06XXXX-43E5-11E4-916C-0800200C9A66
    static func createUUID(_ shortId: String) -> CBUUID {
        return CBUUID(string: "CE06\(shortId)-43E5-11E4-916C-0800200C9A66")
    }
    
    // Core BLE Services
    static let gap = CBUUID(string: "1800")
    static let deviceInformation = createUUID("0010")
    static let control = createUUID("0020")
    static let rowing = createUUID("0030")
}

// MARK: - GAP Characteristic UUIDs
struct GAPCharacteristicUUIDs {
    static let deviceName = CBUUID(string: "2A00")
    static let appearance = CBUUID(string: "2A01")
    static let privacyFlag = CBUUID(string: "2A02")
    static let reconnectAddress = CBUUID(string: "2A03")
    static let connectionParameters = CBUUID(string: "2A04")
}

// MARK: - Device Information Characteristic UUIDs
struct DeviceInfoCharacteristicUUIDs {
    static let modelNumber = PM5ServiceUUIDs.createUUID("0011")
    static let serialNumber = PM5ServiceUUIDs.createUUID("0012")
    static let hardwareRevision = PM5ServiceUUIDs.createUUID("0013")
    static let firmwareRevision = PM5ServiceUUIDs.createUUID("0014")
    static let manufacturer = PM5ServiceUUIDs.createUUID("0015")
    static let ergMachineType = PM5ServiceUUIDs.createUUID("0016")
    static let attMTU = PM5ServiceUUIDs.createUUID("0017")
    static let llDLE = PM5ServiceUUIDs.createUUID("0018")
}

// MARK: - Control Service Characteristic UUIDs
struct ControlCharacteristicUUIDs {
    static let pmReceive = PM5ServiceUUIDs.createUUID("0021")
    static let pmTransmit = PM5ServiceUUIDs.createUUID("0022")
}

// MARK: - Rowing Service Characteristic UUIDs
struct RowingCharacteristicUUIDs {
    // Core Data Characteristics
    static let generalStatus = PM5ServiceUUIDs.createUUID("0031")
    static let additionalStatus1 = PM5ServiceUUIDs.createUUID("0032")
    static let additionalStatus2 = PM5ServiceUUIDs.createUUID("0033")
    static let sampleRateControl = PM5ServiceUUIDs.createUUID("0034")
    
    // Detailed Data Characteristics
    static let strokeData = PM5ServiceUUIDs.createUUID("0035")
    static let additionalStrokeData = PM5ServiceUUIDs.createUUID("0036")
    static let splitIntervalData = PM5ServiceUUIDs.createUUID("0037")
    static let endOfWorkoutSummary = PM5ServiceUUIDs.createUUID("0039")
    static let heartRateBeltInfo = PM5ServiceUUIDs.createUUID("003B")
    
    // Multiplexed Information
    static let multiplexedInfo = PM5ServiceUUIDs.createUUID("0080")
}

// MARK: - PM5 Constants
struct PM5Constants {
    // Device discovery
    static let deviceNamePrefix = "PM5"
    static let appearance: UInt16 = 0x0000
    
    // Connection parameters
    static let connectionInterval: TimeInterval = 0.030 // 30ms
    static let connectionTimeout: TimeInterval = 10.0 // 10s
    
    // Data limits
    static let maxMTU = 512
    static let defaultMTU = 23
    static let maxDLE = 251
    static let defaultDLE = 27
    
    // Sample rates
    static let sampleRate1Second: UInt8 = 0
    static let sampleRate500ms: UInt8 = 1 // Default
    static let sampleRate250ms: UInt8 = 2
    static let sampleRate100ms: UInt8 = 3
    
    // Invalid values
    static let invalidHeartRate: UInt8 = 255
}

// MARK: - Enumerations
enum WorkoutType: UInt8 {
    case justRowNoSplits = 0
    case justRowSplits = 1
    case fixedDistNoSplits = 2
    case fixedDistSplits = 3
    case fixedTimeNoSplits = 4
    case fixedTimeSplits = 5
    case fixedTimeInterval = 6
    case fixedDistInterval = 7
    case variableInterval = 8
    case variableUndefinedRest = 9
    case fixedCalorieSplits = 10
    case fixedWattMinuteSplits = 11
    case fixedCalsInterval = 12
}

enum WorkoutState: UInt8 {
    case waitToBegin = 0
    case workoutRow = 1
    case countdownPause = 2
    case intervalRest = 3
    case intervalWorkTime = 4
    case intervalWorkDistance = 5
    case workoutEnd = 10
    case terminate = 11
    case workoutLogged = 12
    case rearm = 13
}

enum RowingState: UInt8 {
    case inactive = 0
    case active = 1
}

enum StrokeState: UInt8 {
    case waitingForWheelToReachMinSpeed = 0
    case waitingForWheelToAccelerate = 1
    case driving = 2
    case dwellingAfterDrive = 3
    case recovery = 4
}

enum IntervalType: UInt8 {
    case none = 0
    case time = 1
    case distance = 2
    case rest = 3
    case timeRestUndefined = 4
    case distanceRestUndefined = 5
    case restUndefined = 6
    case calorie = 7
    case wattMinute = 8
    case none255 = 255
}

enum ErgMachineType: UInt8 {
    case staticD = 0
    case staticC = 1
    case staticA = 2
    case staticB = 3
    case staticE = 5
    case staticDynamic = 8
    case slidesA = 16
    case slidesB = 17
    case slidesC = 18
    case slidesD = 19
    case slidesE = 20
    case slidesDynamic = 128
    case staticDyno = 192
    case staticSki = 193
    case staticBike = 194
    case num = 195
}