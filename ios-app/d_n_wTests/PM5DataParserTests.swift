//
//  PM5DataParserTests.swift
//  d_n_wTests
//
//  Created by Development Agent
//

import XCTest
@testable import d_n_w

class PM5DataParserTests: XCTestCase {
    
    // MARK: - Multi-byte Parsing Tests
    
    func test_parseUInt16_withValidData_shouldReturnCorrectValue() throws {
        // ARRANGE - Little endian: 0x3412 = 0x1234
        let data = Data([0x34, 0x12])
        
        // ACT
        let result = PM5DataParser.parseUInt16(data, offset: 0)
        
        // ASSERT
        XCTAssertEqual(result, 0x1234)
    }
    
    func test_parseUInt16_withInsufficientData_shouldReturnZero() throws {
        // ARRANGE
        let data = Data([0x12])
        
        // ACT
        let result = PM5DataParser.parseUInt16(data, offset: 0)
        
        // ASSERT
        XCTAssertEqual(result, 0)
    }
    
    func test_parseUInt16_withOffset_shouldReturnCorrectValue() throws {
        // ARRANGE
        let data = Data([0x00, 0x34, 0x12])
        
        // ACT
        let result = PM5DataParser.parseUInt16(data, offset: 1)
        
        // ASSERT
        XCTAssertEqual(result, 0x1234)
    }
    
    func test_parseUInt24_withValidData_shouldReturnCorrectValue() throws {
        // ARRANGE - Little endian: 0x563412 = 0x123456
        let data = Data([0x56, 0x34, 0x12])
        
        // ACT
        let result = PM5DataParser.parseUInt24(data, offset: 0)
        
        // ASSERT
        XCTAssertEqual(result, 0x123456)
    }
    
    func test_parseUInt24_withInsufficientData_shouldReturnZero() throws {
        // ARRANGE
        let data = Data([0x12, 0x34])
        
        // ACT
        let result = PM5DataParser.parseUInt24(data, offset: 0)
        
        // ASSERT
        XCTAssertEqual(result, 0)
    }
    
    func test_parseUInt32_withValidData_shouldReturnCorrectValue() throws {
        // ARRANGE - Little endian: 0x78563412 = 0x12345678
        let data = Data([0x78, 0x56, 0x34, 0x12])
        
        // ACT
        let result = PM5DataParser.parseUInt32(data, offset: 0)
        
        // ASSERT
        XCTAssertEqual(result, 0x12345678)
    }
    
    func test_parseUInt32_withInsufficientData_shouldReturnZero() throws {
        // ARRANGE
        let data = Data([0x12, 0x34, 0x56])
        
        // ACT
        let result = PM5DataParser.parseUInt32(data, offset: 0)
        
        // ASSERT
        XCTAssertEqual(result, 0)
    }
    
    // MARK: - General Status Parsing Tests
    
    func test_parseGeneralStatus_withValidData_shouldReturnValidStatus() throws {
        // ARRANGE - Create test data for GeneralStatus (minimum 19 bytes)
        var data = Data(count: 19)
        
        // Elapsed time: 12.34 seconds (1234 centiseconds = 0x04D2)
        data[0] = 0xD2
        data[1] = 0x04
        data[2] = 0x00
        
        // Distance: 123.4 meters (1234 decimeters = 0x04D2)
        data[3] = 0xD2
        data[4] = 0x04
        data[5] = 0x00
        
        // Workout type: Just Row No Splits (1)
        data[6] = 0x01
        
        // Interval type: None (0)
        data[7] = 0x00
        
        // Workout state: Workout Row (5)
        data[8] = 0x05
        
        // Rowing state: Active (1)
        data[9] = 0x01
        
        // Stroke state: Recovery (4)
        data[10] = 0x04
        
        // Total work distance: 1000 meters (0x03E8)
        data[11] = 0xE8
        data[12] = 0x03
        data[13] = 0x00
        
        // ACT
        let result = PM5DataParser.parseGeneralStatus(data)
        
        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.elapsedTime ?? 0, 12.34, accuracy: 0.01)
        XCTAssertEqual(result?.distance ?? 0, 123.4, accuracy: 0.1)
        XCTAssertEqual(result?.workoutType, .justRowNoSplits)
        XCTAssertEqual(result?.intervalType, .none)
        XCTAssertEqual(result?.workoutState, .workoutRow)
        XCTAssertEqual(result?.rowingState, .active)
        XCTAssertEqual(result?.strokeState, .recovery)
        XCTAssertEqual(result?.totalWorkDistance ?? 0, 1000.0, accuracy: 0.1)
    }
    
    func test_parseGeneralStatus_withInsufficientData_shouldReturnNil() throws {
        // ARRANGE
        let data = Data(count: 18) // Less than required 19 bytes
        
        // ACT
        let result = PM5DataParser.parseGeneralStatus(data)
        
        // ASSERT
        XCTAssertNil(result)
    }
    
    func test_parseGeneralStatus_withExtendedData_shouldParseOptionalFields() throws {
        // ARRANGE - Create test data with optional fields (21+ bytes)
        var data = Data(count: 21)
        
        // Fill required fields (first 14 bytes)
        for i in 0..<14 {
            data[i] = UInt8(i)
        }
        
        // Workout duration: 30.00 seconds (3000 centiseconds = 0x0BB8)
        data[14] = 0xB8
        data[15] = 0x0B
        data[16] = 0x00
        
        // Workout duration type: Time
        data[17] = 0x40
        
        // Drag factor: 120
        data[18] = 120
        
        // ACT
        let result = PM5DataParser.parseGeneralStatus(data)
        
        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.workoutDuration ?? 0, 30.0, accuracy: 0.01)
        XCTAssertEqual(result?.workoutDurationType ?? 0, 0x40)
        XCTAssertEqual(result?.dragFactor ?? 0, 120)
    }
    
    // MARK: - Additional Status 1 Parsing Tests
    
    func test_parseAdditionalStatus1_withValidData_shouldReturnValidStatus() throws {
        // ARRANGE - Create test data for AdditionalStatus1 (minimum 19 bytes)
        var data = Data(count: 19)
        
        // Elapsed time: 12.34 seconds (1234 centiseconds)
        data[0] = 0xD2
        data[1] = 0x04
        data[2] = 0x00
        
        // Speed: 5.0 m/s (50 dm/s = 0x32)
        data[3] = 0x32
        data[4] = 0x00
        
        // Stroke rate: 24 SPM
        data[5] = 24
        
        // Heart rate: 150 BPM
        data[6] = 150
        
        // Current pace: 120.5 seconds/500m (12050 = 0x2F12)
        data[7] = 0x12
        data[8] = 0x2F
        
        // Average pace: 125.0 seconds/500m (12500 = 0x30D4)
        data[9] = 0xD4
        data[10] = 0x30
        
        // Rest distance: 0
        data[11] = 0x00
        data[12] = 0x00
        
        // Rest time: 0
        data[13] = 0x00
        data[14] = 0x00
        data[15] = 0x00
        
        // Erg machine type: Static D (5)
        data[16] = 0x05
        
        // ACT
        let result = PM5DataParser.parseAdditionalStatus1(data)
        
        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.elapsedTime ?? 0, 12.34, accuracy: 0.01)
        XCTAssertEqual(result?.speed ?? 0, 5.0, accuracy: 0.1)
        XCTAssertEqual(result?.strokeRate ?? 0, 24)
        XCTAssertEqual(result?.heartRate ?? 0, 150)
        XCTAssertEqual(result?.currentPace ?? 0, 120.5, accuracy: 0.1)
        XCTAssertEqual(result?.averagePace ?? 0, 125.0, accuracy: 0.1)
        XCTAssertEqual(result?.restDistance ?? 0, 0)
        XCTAssertEqual(result?.restTime ?? 0, 0)
        XCTAssertEqual(result?.ergMachineType, .staticD)
    }
    
    func test_parseAdditionalStatus1_withInsufficientData_shouldReturnNil() throws {
        // ARRANGE
        let data = Data(count: 16) // Less than required 17 bytes
        
        // ACT
        let result = PM5DataParser.parseAdditionalStatus1(data)
        
        // ASSERT
        XCTAssertNil(result)
    }
    
    // MARK: - Additional Status 2 Parsing Tests
    
    func test_parseAdditionalStatus2_withValidData_shouldReturnValidStatus() throws {
        // ARRANGE - Create test data for AdditionalStatus2 (minimum 21 bytes)
        var data = Data(count: 21)
        
        // Elapsed time: 12.34 seconds
        data[0] = 0xD2
        data[1] = 0x04
        data[2] = 0x00
        
        // Interval count: 1
        data[3] = 0x01
        
        // Average power: 250 watts (0x00FA)
        data[4] = 0xFA
        data[5] = 0x00
        
        // Total calories: 45 (0x002D)
        data[6] = 0x2D
        data[7] = 0x00
        
        // Split interval average pace: 120.0 s/500m (12000 = 0x2EE0)
        data[8] = 0xE0
        data[9] = 0x2E
        
        // Split interval average power: 240 watts (0x00F0)
        data[10] = 0xF0
        data[11] = 0x00
        
        // Split interval average calories: 300 (0x012C)
        data[12] = 0x2C
        data[13] = 0x01
        
        // Last split time: 60.0 seconds (6000 centiseconds = 0x1770)
        data[14] = 0x70
        data[15] = 0x17
        data[16] = 0x00
        
        // Last split distance: 500.0 meters (5000 decimeters = 0x1388)
        data[17] = 0x88
        data[18] = 0x13
        data[19] = 0x00
        
        // ACT
        let result = PM5DataParser.parseAdditionalStatus2(data)
        
        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.elapsedTime ?? 0, 12.34, accuracy: 0.01)
        XCTAssertEqual(result?.intervalCount ?? 0, 1)
        XCTAssertEqual(result?.averagePower ?? 0, 250)
        XCTAssertEqual(result?.totalCalories ?? 0, 45)
        XCTAssertEqual(result?.splitIntervalAvgPace ?? 0, 120.0, accuracy: 0.1)
        XCTAssertEqual(result?.splitIntervalAvgPower ?? 0, 240)
        XCTAssertEqual(result?.splitIntervalAvgCalories ?? 0, 300)
        XCTAssertEqual(result?.lastSplitTime ?? 0, 60.0, accuracy: 0.1)
        XCTAssertEqual(result?.lastSplitDistance ?? 0, 500.0, accuracy: 0.1)
    }
    
    func test_parseAdditionalStatus2_withInsufficientData_shouldReturnNil() throws {
        // ARRANGE
        let data = Data(count: 19) // Less than required 20 bytes
        
        // ACT
        let result = PM5DataParser.parseAdditionalStatus2(data)
        
        // ASSERT
        XCTAssertNil(result)
    }
    
    // MARK: - Stroke Data Parsing Tests
    
    func test_parseStrokeData_withValidData_shouldReturnValidStroke() throws {
        // ARRANGE - Create test data for StrokeData (32 bytes)
        var data = Data(count: 32)
        
        // Elapsed time: 12.34 seconds
        data[0] = 0xD2
        data[1] = 0x04
        data[2] = 0x00
        
        // Distance: 123.4 meters
        data[3] = 0xD2
        data[4] = 0x04
        data[5] = 0x00
        
        // Drive length: 1.45 meters (145 cm = 0x0091)
        data[6] = 0x91
        data[7] = 0x00
        
        // Drive time: 0.80 seconds (80 cs = 0x0050)
        data[8] = 0x50
        data[9] = 0x00
        
        // Stroke recovery time: 1.20 seconds (120 cs = 0x0078)
        data[10] = 0x78
        data[11] = 0x00
        
        // Stroke distance: 10.0 meters (100 dm = 0x0064)
        data[12] = 0x64
        data[13] = 0x00
        
        // Peak drive force: 45.0 lbs (450 = 0x01C2)
        data[14] = 0xC2
        data[15] = 0x01
        
        // Average drive force: 28.0 lbs (280 = 0x0118)
        data[16] = 0x18
        data[17] = 0x01
        
        // Work per stroke: 350.0 J (3500 = 0x0DAC)
        data[18] = 0xAC
        data[19] = 0x0D
        
        // Stroke count: 25 (0x0019)
        data[20] = 0x19
        data[21] = 0x00
        
        // ACT
        let result = PM5DataParser.parseStrokeData(data)
        
        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.elapsedTime ?? 0, 12.34, accuracy: 0.01)
        XCTAssertEqual(result?.distance ?? 0, 123.4, accuracy: 0.1)
        XCTAssertEqual(result?.driveLength ?? 0, 1.45, accuracy: 0.01)
        XCTAssertEqual(result?.driveTime ?? 0, 0.80, accuracy: 0.01)
        XCTAssertEqual(result?.recoveryTime ?? 0, 1.20, accuracy: 0.01)
        XCTAssertEqual(result?.strokeDistance ?? 0, 10.0, accuracy: 0.1)
        XCTAssertEqual(result?.peakDriveForce ?? 0, 45.0, accuracy: 0.1)
        XCTAssertEqual(result?.averageDriveForce ?? 0, 28.0, accuracy: 0.1)
        XCTAssertEqual(result?.workPerStroke ?? 0, 350.0, accuracy: 0.1)
        XCTAssertEqual(result?.strokeCount ?? 0, 25)
    }
    
    func test_parseStrokeData_withInsufficientData_shouldReturnNil() throws {
        // ARRANGE
        let data = Data(count: 21) // Less than required 22 bytes
        
        // ACT
        let result = PM5DataParser.parseStrokeData(data)
        
        // ASSERT
        XCTAssertNil(result)
    }
    
    // MARK: - Multiplexed Info Parsing Tests
    
    func test_parseMultiplexedInfo_withValidData_shouldReturnIdentifierAndData() throws {
        // ARRANGE
        let identifier: UInt8 = 0x31 // General Status identifier
        let testData = Data([0x01, 0x02, 0x03, 0x04])
        var multiplexedData = Data()
        multiplexedData.append(identifier)
        multiplexedData.append(testData)
        
        // ACT
        let result = PM5DataParser.parseMultiplexedInfo(multiplexedData)
        
        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.0, identifier)
        XCTAssertEqual(result?.1, testData)
    }
    
    func test_parseMultiplexedInfo_withInsufficientData_shouldReturnNil() throws {
        // ARRANGE
        let data = Data() // Empty data
        
        // ACT
        let result = PM5DataParser.parseMultiplexedInfo(data)
        
        // ASSERT
        XCTAssertNil(result)
    }
    
    // MARK: - Edge Case Tests
    
    func test_parseGeneralStatus_withEmptyData_shouldReturnNil() throws {
        // ARRANGE
        let data = Data()
        
        // ACT
        let result = PM5DataParser.parseGeneralStatus(data)
        
        // ASSERT
        XCTAssertNil(result)
    }
    
    func test_parseUInt16_withMaxOffset_shouldReturnZero() throws {
        // ARRANGE
        let data = Data([0x12, 0x34])
        
        // ACT
        let result = PM5DataParser.parseUInt16(data, offset: 2)
        
        // ASSERT
        XCTAssertEqual(result, 0)
    }
}