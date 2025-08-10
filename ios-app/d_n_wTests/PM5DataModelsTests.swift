//
//  PM5DataModelsTests.swift
//  d_n_wTests
//
//  Created by Development Agent
//

import XCTest
@testable import d_n_w

class PM5DataModelsTests: XCTestCase {
    
    // MARK: - GeneralStatus Tests
    
    func test_GeneralStatus_init_shouldSetAllProperties() throws {
        // ARRANGE
        let elapsedTime: TimeInterval = 123.45
        let distance: Double = 678.9
        let workoutType: WorkoutType = .justRowNoSplits
        let intervalType: IntervalType? = nil
        let workoutState: WorkoutState = .workoutRow
        let rowingState: RowingState = .active
        let strokeState: StrokeState = .recovery
        let totalWorkDistance: Double = 1000.0
        let workoutDuration: TimeInterval = 300.0
        let workoutDurationType: UInt8 = 0x40
        let dragFactor: UInt8 = 120
        
        // ACT
        let generalStatus = GeneralStatus(
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
        
        // ASSERT
        XCTAssertEqual(generalStatus.elapsedTime, elapsedTime)
        XCTAssertEqual(generalStatus.distance, distance)
        XCTAssertEqual(generalStatus.workoutType, workoutType)
        XCTAssertEqual(generalStatus.intervalType, intervalType)
        XCTAssertEqual(generalStatus.workoutState, workoutState)
        XCTAssertEqual(generalStatus.rowingState, rowingState)
        XCTAssertEqual(generalStatus.strokeState, strokeState)
        XCTAssertEqual(generalStatus.totalWorkDistance, totalWorkDistance)
        XCTAssertEqual(generalStatus.workoutDuration, workoutDuration)
        XCTAssertEqual(generalStatus.workoutDurationType, workoutDurationType)
        XCTAssertEqual(generalStatus.dragFactor, dragFactor)
    }
    
    func test_GeneralStatus_withOptionalNils_shouldWorkCorrectly() throws {
        // ARRANGE & ACT
        let generalStatus = GeneralStatus(
            elapsedTime: 100.0,
            distance: 200.0,
            workoutType: .justRowNoSplits,
            intervalType: .none,
            workoutState: .workoutRow,
            rowingState: .active,
            strokeState: .recovery,
            totalWorkDistance: 300.0,
            workoutDuration: nil,
            workoutDurationType: nil,
            dragFactor: nil
        )
        
        // ASSERT
        XCTAssertNil(generalStatus.workoutDuration)
        XCTAssertNil(generalStatus.workoutDurationType)
        XCTAssertNil(generalStatus.dragFactor)
    }
    
    // MARK: - AdditionalStatus1 Tests
    
    func test_AdditionalStatus1_init_shouldSetAllProperties() throws {
        // ARRANGE
        let elapsedTime: TimeInterval = 123.45
        let speed: Double = 5.5
        let strokeRate: UInt8 = 24
        let heartRate: UInt8 = 150
        let currentPace: TimeInterval = 120.5
        let averagePace: TimeInterval = 125.0
        let restDistance: UInt16 = 100
        let restTime: TimeInterval = 30.0
        let ergMachineType: ErgMachineType = .staticD
        
        // ACT
        let additionalStatus1 = AdditionalStatus1(
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
        
        // ASSERT
        XCTAssertEqual(additionalStatus1.elapsedTime, elapsedTime)
        XCTAssertEqual(additionalStatus1.speed, speed)
        XCTAssertEqual(additionalStatus1.strokeRate, strokeRate)
        XCTAssertEqual(additionalStatus1.heartRate, heartRate)
        XCTAssertEqual(additionalStatus1.currentPace, currentPace)
        XCTAssertEqual(additionalStatus1.averagePace, averagePace)
        XCTAssertEqual(additionalStatus1.restDistance, restDistance)
        XCTAssertEqual(additionalStatus1.restTime, restTime)
        XCTAssertEqual(additionalStatus1.ergMachineType, ergMachineType)
    }
    
    func test_AdditionalStatus1_withInvalidHeartRate_shouldAcceptValue() throws {
        // ARRANGE & ACT
        let additionalStatus1 = AdditionalStatus1(
            elapsedTime: 100.0,
            speed: 5.0,
            strokeRate: 20,
            heartRate: PM5Constants.invalidHeartRate, // 255
            currentPace: 120.0,
            averagePace: 120.0,
            restDistance: 0,
            restTime: 0.0,
            ergMachineType: .staticD
        )
        
        // ASSERT
        XCTAssertEqual(additionalStatus1.heartRate, PM5Constants.invalidHeartRate)
    }
    
    // MARK: - AdditionalStatus2 Tests
    
    func test_AdditionalStatus2_init_shouldSetAllProperties() throws {
        // ARRANGE
        let elapsedTime: TimeInterval = 123.45
        let intervalCount: UInt8 = 1
        let averagePower: UInt16 = 250
        let totalCalories: UInt16 = 45
        let splitIntervalAvgPace: TimeInterval = 120.0
        let splitIntervalAvgPower: UInt16 = 240
        let splitIntervalAvgCalories: UInt16 = 300
        let lastSplitTime: TimeInterval = 60.0
        let lastSplitDistance: Double = 500.0
        
        // ACT
        let additionalStatus2 = AdditionalStatus2(
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
        
        // ASSERT
        XCTAssertEqual(additionalStatus2.elapsedTime, elapsedTime)
        XCTAssertEqual(additionalStatus2.intervalCount, intervalCount)
        XCTAssertEqual(additionalStatus2.averagePower, averagePower)
        XCTAssertEqual(additionalStatus2.totalCalories, totalCalories)
        XCTAssertEqual(additionalStatus2.splitIntervalAvgPace, splitIntervalAvgPace)
        XCTAssertEqual(additionalStatus2.splitIntervalAvgPower, splitIntervalAvgPower)
        XCTAssertEqual(additionalStatus2.splitIntervalAvgCalories, splitIntervalAvgCalories)
        XCTAssertEqual(additionalStatus2.lastSplitTime, lastSplitTime)
        XCTAssertEqual(additionalStatus2.lastSplitDistance, lastSplitDistance)
    }
    
    // MARK: - StrokeData Tests
    
    func test_StrokeData_init_shouldSetAllProperties() throws {
        // ARRANGE
        let elapsedTime: TimeInterval = 123.45
        let distance: Double = 678.9
        let driveLength: Double = 1.45
        let driveTime: TimeInterval = 0.80
        let recoveryTime: TimeInterval = 1.20
        let strokeDistance: Double = 10.0
        let peakDriveForce: Double = 45.0
        let averageDriveForce: Double = 28.0
        let workPerStroke: Double = 350.0
        let strokeCount: UInt16 = 25
        
        // ACT
        let strokeData = StrokeData(
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
        
        // ASSERT
        XCTAssertEqual(strokeData.elapsedTime, elapsedTime)
        XCTAssertEqual(strokeData.distance, distance)
        XCTAssertEqual(strokeData.driveLength, driveLength)
        XCTAssertEqual(strokeData.driveTime, driveTime)
        XCTAssertEqual(strokeData.recoveryTime, recoveryTime)
        XCTAssertEqual(strokeData.strokeDistance, strokeDistance)
        XCTAssertEqual(strokeData.peakDriveForce, peakDriveForce)
        XCTAssertEqual(strokeData.averageDriveForce, averageDriveForce)
        XCTAssertEqual(strokeData.workPerStroke, workPerStroke)
        XCTAssertEqual(strokeData.strokeCount, strokeCount)
    }
    
    // MARK: - PM5RowingData Tests
    
    func test_PM5RowingData_init_shouldHaveNilValues() throws {
        // ACT
        let rowingData = PM5RowingData()
        
        // ASSERT
        XCTAssertNil(rowingData.generalStatus)
        XCTAssertNil(rowingData.additionalStatus1)
        XCTAssertNil(rowingData.additionalStatus2)
        XCTAssertNil(rowingData.strokeData)
        XCTAssertNil(rowingData.additionalStrokeData)
        XCTAssertNil(rowingData.splitIntervalData)
        XCTAssertNil(rowingData.heartRateBeltInfo)
        XCTAssertNotNil(rowingData.lastUpdate)
    }
    
    func test_PM5RowingData_setGeneralStatus_shouldUpdateProperty() throws {
        // ARRANGE
        var rowingData = PM5RowingData()
        let generalStatus = GeneralStatus(
            elapsedTime: 100.0,
            distance: 200.0,
            workoutType: .justRowNoSplits,
            intervalType: .none,
            workoutState: .workoutRow,
            rowingState: .active,
            strokeState: .recovery,
            totalWorkDistance: 300.0,
            workoutDuration: nil,
            workoutDurationType: nil,
            dragFactor: nil
        )
        
        // ACT
        rowingData.generalStatus = generalStatus
        
        // ASSERT
        XCTAssertNotNil(rowingData.generalStatus)
        XCTAssertEqual(rowingData.generalStatus?.elapsedTime, 100.0)
        XCTAssertEqual(rowingData.generalStatus?.distance, 200.0)
    }
    
    func test_PM5RowingData_setLastUpdate_shouldUpdateProperty() throws {
        // ARRANGE
        var rowingData = PM5RowingData()
        let updateTime = Date()
        
        // ACT
        rowingData.lastUpdate = updateTime
        
        // ASSERT
        XCTAssertEqual(rowingData.lastUpdate, updateTime)
    }
    
    // MARK: - PM5DeviceInfo Tests
    
    func test_PM5DeviceInfo_init_shouldSetAllProperties() throws {
        // ARRANGE
        let modelNumber = "Model D/E"
        let serialNumber = "PM5-12345"
        let hardwareRevision = "633"
        let firmwareRevision = "163"
        let manufacturer = "Concept2"
        let ergMachineType: ErgMachineType = .staticD
        let attMTU: UInt16 = 244
        let llDLE: UInt16 = 244
        
        // ACT
        let deviceInfo = PM5DeviceInfo(
            modelNumber: modelNumber,
            serialNumber: serialNumber,
            hardwareRevision: hardwareRevision,
            firmwareRevision: firmwareRevision,
            manufacturer: manufacturer,
            ergMachineType: ergMachineType,
            attMTU: attMTU,
            llDLE: llDLE
        )
        
        // ASSERT
        XCTAssertEqual(deviceInfo.modelNumber, modelNumber)
        XCTAssertEqual(deviceInfo.serialNumber, serialNumber)
        XCTAssertEqual(deviceInfo.hardwareRevision, hardwareRevision)
        XCTAssertEqual(deviceInfo.firmwareRevision, firmwareRevision)
        XCTAssertEqual(deviceInfo.manufacturer, manufacturer)
        XCTAssertEqual(deviceInfo.ergMachineType, ergMachineType)
        XCTAssertEqual(deviceInfo.attMTU, attMTU)
        XCTAssertEqual(deviceInfo.llDLE, llDLE)
    }
    
    // MARK: - Data Validation Tests
    
    func test_GeneralStatus_withZeroValues_shouldAcceptValues() throws {
        // ACT
        let generalStatus = GeneralStatus(
            elapsedTime: 0,
            distance: 0,
            workoutType: .justRowNoSplits,
            intervalType: .none,
            workoutState: .waitToBegin,
            rowingState: .inactive,
            strokeState: .waitingForWheelToReachMinSpeed,
            totalWorkDistance: 0,
            workoutDuration: 0,
            workoutDurationType: 0,
            dragFactor: 0
        )
        
        // ASSERT
        XCTAssertEqual(generalStatus.elapsedTime, 0)
        XCTAssertEqual(generalStatus.distance, 0)
        XCTAssertEqual(generalStatus.totalWorkDistance, 0)
    }
    
    func test_AdditionalStatus1_withMaxValues_shouldAcceptValues() throws {
        // ACT
        let additionalStatus1 = AdditionalStatus1(
            elapsedTime: TimeInterval.greatestFiniteMagnitude,
            speed: Double.greatestFiniteMagnitude,
            strokeRate: UInt8.max,
            heartRate: UInt8.max,
            currentPace: TimeInterval.greatestFiniteMagnitude,
            averagePace: TimeInterval.greatestFiniteMagnitude,
            restDistance: UInt16.max,
            restTime: TimeInterval.greatestFiniteMagnitude,
            ergMachineType: .num
        )
        
        // ASSERT
        XCTAssertEqual(additionalStatus1.strokeRate, UInt8.max)
        XCTAssertEqual(additionalStatus1.heartRate, UInt8.max)
        XCTAssertEqual(additionalStatus1.restDistance, UInt16.max)
    }
    
    // MARK: - Struct Copying Tests
    
    func test_GeneralStatus_shouldBeCopyable() throws {
        // ARRANGE
        let originalStatus = GeneralStatus(
            elapsedTime: 100.0,
            distance: 200.0,
            workoutType: .justRowNoSplits,
            intervalType: .none,
            workoutState: .workoutRow,
            rowingState: .active,
            strokeState: .recovery,
            totalWorkDistance: 300.0,
            workoutDuration: 400.0,
            workoutDurationType: 0x40,
            dragFactor: 120
        )
        
        // ACT
        let copiedStatus = originalStatus
        
        // ASSERT
        XCTAssertEqual(copiedStatus.elapsedTime, originalStatus.elapsedTime)
        XCTAssertEqual(copiedStatus.distance, originalStatus.distance)
        XCTAssertEqual(copiedStatus.workoutType, originalStatus.workoutType)
        XCTAssertEqual(copiedStatus.dragFactor, originalStatus.dragFactor)
    }
}