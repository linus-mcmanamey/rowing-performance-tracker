//
//  CSAFEProtocol.swift
//  d_n_w
//
//  CSAFE Protocol Implementation for PM5
//

import Foundation

// MARK: - CSAFE Frame Structure
struct CSAFEFrame {
    static let startByte: UInt8 = 0xF1
    static let endByte: UInt8 = 0xF2
    static let extendedStartByte: UInt8 = 0xF0
    static let stuffByte: UInt8 = 0xF3
    
    let contents: Data
    let isExtended: Bool
    let destination: UInt8?
    let source: UInt8?
    
    init(contents: Data, isExtended: Bool = false, destination: UInt8? = nil, source: UInt8? = nil) {
        self.contents = contents
        self.isExtended = isExtended
        self.destination = destination
        self.source = source
    }
    
    // Build the complete frame with stuffing and checksum
    func buildFrame() -> Data {
        var frame = Data()
        
        if isExtended {
            frame.append(CSAFEFrame.extendedStartByte)
            if let dest = destination { frame.append(dest) }
            if let src = source { frame.append(src) }
        } else {
            frame.append(CSAFEFrame.startByte)
        }
        
        // Apply byte stuffing to contents
        let stuffedContents = applyByteStuffing(contents)
        frame.append(stuffedContents)
        
        // Calculate and append checksum
        let checksum = calculateChecksum(frame.subdata(in: 1..<frame.count))
        frame.append(checksum)
        
        // Append end byte
        frame.append(CSAFEFrame.endByte)
        
        return frame
    }
    
    private func applyByteStuffing(_ data: Data) -> Data {
        var stuffed = Data()
        
        for byte in data {
            switch byte {
            case 0xF0:
                stuffed.append(contentsOf: [CSAFEFrame.stuffByte, 0x00])
            case 0xF1:
                stuffed.append(contentsOf: [CSAFEFrame.stuffByte, 0x01])
            case 0xF2:
                stuffed.append(contentsOf: [CSAFEFrame.stuffByte, 0x02])
            case 0xF3:
                stuffed.append(contentsOf: [CSAFEFrame.stuffByte, 0x03])
            default:
                stuffed.append(byte)
            }
        }
        
        return stuffed
    }
    
    private func calculateChecksum(_ data: Data) -> UInt8 {
        var checksum: UInt8 = 0
        for byte in data {
            checksum ^= byte
        }
        return checksum
    }
}

// MARK: - CSAFE Commands
enum CSAFECommand: UInt8 {
    // Status Commands
    case getStatus = 0x80
    case reset = 0x81
    case goIdle = 0x82
    case goHaveId = 0x83
    case goInUse = 0x85
    case goFinished = 0x86
    case goReady = 0x87
    case badId = 0x88
    
    // Configuration Commands
    case getVersion = 0x91
    case getId = 0x92
    case getUnits = 0x93
    case getSerial = 0x94
    case getList = 0x98
    case getUtilization = 0x99
    case getMotorCurrent = 0x9A
    case getOdometer = 0x9B
    case getErrorCode = 0x9C
    case getServiceCode = 0x9D
    case getUserInfo = 0x9E
    case getTorque = 0x9F
    
    // Workout Commands
    case setWorkoutType = 0x76
    case setWorkoutDuration = 0x20
    case setWorkoutDistance = 0x21
    case setWorkoutCalories = 0x22
    case setWorkoutProgram = 0x24
    case setWorkoutPower = 0x34
    case setWorkoutHR = 0x35
    
    // Control Commands
    case goToWorkoutScreen = 0x76
    case setDateTime = 0x37
    case setUserInfo = 0x1A
    
    var dataLength: Int {
        switch self {
        case .setWorkoutType:
            return 5  // [0x76] [0x02] [0x01] [0x01] [WorkoutType]
        case .goToWorkoutScreen:
            return 6  // [0x76] [0x04] [0x13] [0x02] [0x01] [0x01]
        default:
            return 1
        }
    }
}

// MARK: - CSAFE Command Builder
class CSAFECommandBuilder {
    
    // MARK: - Status Commands
    static func getStatus() -> Data {
        let frame = CSAFEFrame(contents: Data([CSAFECommand.getStatus.rawValue]))
        return frame.buildFrame()
    }
    
    static func reset() -> Data {
        let frame = CSAFEFrame(contents: Data([CSAFECommand.reset.rawValue]))
        return frame.buildFrame()
    }
    
    // MARK: - Workout Commands
    static func setWorkoutType(_ workoutType: WorkoutType) -> Data {
        let contents = Data([
            CSAFECommand.setWorkoutType.rawValue,
            0x02,  // Data length
            0x01,  // Sub-command
            0x01,  // Sub-data length
            workoutType.rawValue
        ])
        let frame = CSAFEFrame(contents: contents)
        return frame.buildFrame()
    }
    
    static func goToWorkoutScreen() -> Data {
        let contents = Data([
            CSAFECommand.setWorkoutType.rawValue,  // Uses same command as setWorkoutType
            0x04,  // Data length
            0x13,  // Sub-command for "go to workout screen"
            0x02,  // Sub-data length
            0x01,  // Parameter 1
            0x01   // Parameter 2
        ])
        let frame = CSAFEFrame(contents: contents)
        return frame.buildFrame()
    }
    
    static func setWorkoutDuration(hours: UInt8, minutes: UInt8, seconds: UInt8) -> Data {
        let contents = Data([
            CSAFECommand.setWorkoutDuration.rawValue,
            0x03,  // Data length
            hours,
            minutes,
            seconds
        ])
        let frame = CSAFEFrame(contents: contents)
        return frame.buildFrame()
    }
    
    static func setWorkoutDistance(_ meters: UInt32) -> Data {
        let distanceBytes = withUnsafeBytes(of: meters.bigEndian) { Array($0.suffix(3)) }
        let contents = Data([
            CSAFECommand.setWorkoutDistance.rawValue,
            0x03  // Data length
        ] + distanceBytes)
        let frame = CSAFEFrame(contents: contents)
        return frame.buildFrame()
    }
    
    static func setWorkoutCalories(_ calories: UInt16) -> Data {
        let calorieBytes = withUnsafeBytes(of: calories.bigEndian) { Array($0) }
        let contents = Data([
            CSAFECommand.setWorkoutCalories.rawValue,
            0x02  // Data length
        ] + calorieBytes)
        let frame = CSAFEFrame(contents: contents)
        return frame.buildFrame()
    }
    
    // MARK: - Information Commands
    static func getVersion() -> Data {
        let frame = CSAFEFrame(contents: Data([CSAFECommand.getVersion.rawValue]))
        return frame.buildFrame()
    }
    
    static func getSerial() -> Data {
        let frame = CSAFEFrame(contents: Data([CSAFECommand.getSerial.rawValue]))
        return frame.buildFrame()
    }
    
    static func getOdometer() -> Data {
        let frame = CSAFEFrame(contents: Data([CSAFECommand.getOdometer.rawValue]))
        return frame.buildFrame()
    }
    
    // MARK: - User Info Commands
    static func setUserInfo(age: UInt8, weight: UInt16, gender: UInt8) -> Data {
        let weightBytes = withUnsafeBytes(of: weight.bigEndian) { Array($0) }
        let contents = Data([
            CSAFECommand.setUserInfo.rawValue,
            0x04,  // Data length
            age,
            gender
        ] + weightBytes)
        let frame = CSAFEFrame(contents: contents)
        return frame.buildFrame()
    }
}

// MARK: - CSAFE Response Parser
class CSAFEResponseParser {
    
    static func parseResponse(_ data: Data) -> CSAFEResponse? {
        guard data.count >= 4 else { return nil }  // Minimum frame size
        guard data.first == CSAFEFrame.startByte || data.first == CSAFEFrame.extendedStartByte else {
            return nil
        }
        guard data.last == CSAFEFrame.endByte else { return nil }
        
        // Remove frame markers and extract contents
        let frameData = data.dropFirst().dropLast()  // Remove start and end bytes
        let contentsData = frameData.dropLast()      // Remove checksum
        
        // Verify checksum
        let receivedChecksum = frameData.last!
        let calculatedChecksum = calculateChecksum(contentsData)
        guard receivedChecksum == calculatedChecksum else {
            return nil
        }
        
        // Remove byte stuffing
        let unstuffedData = removeByteStuffing(contentsData)
        
        return CSAFEResponse(data: unstuffedData)
    }
    
    private static func removeByteStuffing(_ data: Data) -> Data {
        var unstuffed = Data()
        var i = 0
        
        while i < data.count {
            if data[i] == CSAFEFrame.stuffByte && i + 1 < data.count {
                switch data[i + 1] {
                case 0x00:
                    unstuffed.append(0xF0)
                case 0x01:
                    unstuffed.append(0xF1)
                case 0x02:
                    unstuffed.append(0xF2)
                case 0x03:
                    unstuffed.append(0xF3)
                default:
                    unstuffed.append(data[i])
                    i -= 1  // Don't skip next byte
                }
                i += 2
            } else {
                unstuffed.append(data[i])
                i += 1
            }
        }
        
        return unstuffed
    }
    
    private static func calculateChecksum(_ data: Data) -> UInt8 {
        var checksum: UInt8 = 0
        for byte in data {
            checksum ^= byte
        }
        return checksum
    }
}

// MARK: - CSAFE Response
struct CSAFEResponse {
    let data: Data
    
    var statusByte: UInt8? {
        return data.first
    }
    
    var isSuccess: Bool {
        guard let status = statusByte else { return false }
        return status == 0x00  // Success status
    }
    
    var payload: Data {
        return data.count > 1 ? data.dropFirst() : Data()
    }
}

// MARK: - PM5 CSAFE Extensions
extension PM5Controller {
    
    // Common PM5 commands using CSAFE protocol
    func startJustRowWorkout() {
        let command = CSAFECommandBuilder.setWorkoutType(.justRowNoSplits)
        sendCSAFECommand(command)
        
        // Navigate to workout screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let goCommand = CSAFECommandBuilder.goToWorkoutScreen()
            self.sendCSAFECommand(goCommand)
        }
    }
    
    func startDistanceWorkout(meters: UInt32) {
        let typeCommand = CSAFECommandBuilder.setWorkoutType(.fixedDistNoSplits)
        sendCSAFECommand(typeCommand)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let distanceCommand = CSAFECommandBuilder.setWorkoutDistance(meters)
            self.sendCSAFECommand(distanceCommand)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let goCommand = CSAFECommandBuilder.goToWorkoutScreen()
            self.sendCSAFECommand(goCommand)
        }
    }
    
    func startTimeWorkout(minutes: UInt8, seconds: UInt8) {
        let typeCommand = CSAFECommandBuilder.setWorkoutType(.fixedTimeNoSplits)
        sendCSAFECommand(typeCommand)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let timeCommand = CSAFECommandBuilder.setWorkoutDuration(hours: 0, minutes: minutes, seconds: seconds)
            self.sendCSAFECommand(timeCommand)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let goCommand = CSAFECommandBuilder.goToWorkoutScreen()
            self.sendCSAFECommand(goCommand)
        }
    }
    
    func requestPM5Status() {
        let command = CSAFECommandBuilder.getStatus()
        sendCSAFECommand(command)
    }
    
    func requestPM5Version() {
        let command = CSAFECommandBuilder.getVersion()
        sendCSAFECommand(command)
    }
    
    func configureUser(age: UInt8, weight: UInt16, gender: UInt8) {
        let command = CSAFECommandBuilder.setUserInfo(age: age, weight: weight, gender: gender)
        sendCSAFECommand(command)
    }
}