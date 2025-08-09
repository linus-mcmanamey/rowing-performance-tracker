//
//  PM5ConstantsTests.swift
//  d_n_wTests
//
//  Created by Development Agent
//

import XCTest
import CoreBluetooth
@testable import d_n_w

class PM5ConstantsTests: XCTestCase {
    
    // MARK: - Service UUID Tests
    
    func test_PM5ServiceUUIDs_deviceInformation_shouldHaveCorrectUUID() throws {
        let expected = "CE060010-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(PM5ServiceUUIDs.deviceInformation.uuidString, expected)
    }
    
    func test_PM5ServiceUUIDs_control_shouldHaveCorrectUUID() throws {
        let expected = "CE060020-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(PM5ServiceUUIDs.control.uuidString, expected)
    }
    
    func test_PM5ServiceUUIDs_rowing_shouldHaveCorrectUUID() throws {
        let expected = "CE060030-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(PM5ServiceUUIDs.rowing.uuidString, expected)
    }
    
    func test_PM5ServiceUUIDs_createUUID_shouldGenerateCorrectPattern() throws {
        let result = PM5ServiceUUIDs.createUUID("1234")
        let expected = "CE061234-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(result.uuidString, expected)
    }
    
    // MARK: - GAP Characteristic UUID Tests
    
    func test_GAPCharacteristicUUIDs_deviceName_shouldHaveStandardUUID() throws {
        XCTAssertEqual(GAPCharacteristicUUIDs.deviceName.uuidString, "2A00")
    }
    
    func test_GAPCharacteristicUUIDs_appearance_shouldHaveStandardUUID() throws {
        XCTAssertEqual(GAPCharacteristicUUIDs.appearance.uuidString, "2A01")
    }
    
    // MARK: - Device Information Characteristic UUID Tests
    
    func test_DeviceInfoCharacteristicUUIDs_modelNumber_shouldHaveCorrectUUID() throws {
        let expected = "CE060011-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(DeviceInfoCharacteristicUUIDs.modelNumber.uuidString, expected)
    }
    
    func test_DeviceInfoCharacteristicUUIDs_serialNumber_shouldHaveCorrectUUID() throws {
        let expected = "CE060012-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(DeviceInfoCharacteristicUUIDs.serialNumber.uuidString, expected)
    }
    
    func test_DeviceInfoCharacteristicUUIDs_manufacturer_shouldHaveCorrectUUID() throws {
        let expected = "CE060015-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(DeviceInfoCharacteristicUUIDs.manufacturer.uuidString, expected)
    }
    
    // MARK: - Control Characteristic UUID Tests
    
    func test_ControlCharacteristicUUIDs_pmReceive_shouldHaveCorrectUUID() throws {
        let expected = "CE060021-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(ControlCharacteristicUUIDs.pmReceive.uuidString, expected)
    }
    
    func test_ControlCharacteristicUUIDs_pmTransmit_shouldHaveCorrectUUID() throws {
        let expected = "CE060022-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(ControlCharacteristicUUIDs.pmTransmit.uuidString, expected)
    }
    
    // MARK: - Rowing Characteristic UUID Tests
    
    func test_RowingCharacteristicUUIDs_generalStatus_shouldHaveCorrectUUID() throws {
        let expected = "CE060031-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(RowingCharacteristicUUIDs.generalStatus.uuidString, expected)
    }
    
    func test_RowingCharacteristicUUIDs_additionalStatus1_shouldHaveCorrectUUID() throws {
        let expected = "CE060032-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(RowingCharacteristicUUIDs.additionalStatus1.uuidString, expected)
    }
    
    func test_RowingCharacteristicUUIDs_strokeData_shouldHaveCorrectUUID() throws {
        let expected = "CE060035-43E5-11E4-916C-0800200C9A66"
        XCTAssertEqual(RowingCharacteristicUUIDs.strokeData.uuidString, expected)
    }
    
    // MARK: - PM5 Constants Tests
    
    func test_PM5Constants_deviceNamePrefix_shouldBeCorrect() throws {
        XCTAssertEqual(PM5Constants.deviceNamePrefix, "PM5")
    }
    
    func test_PM5Constants_appearance_shouldBeZero() throws {
        XCTAssertEqual(PM5Constants.appearance, 0x0000)
    }
    
    func test_PM5Constants_connectionInterval_shouldBe30ms() throws {
        XCTAssertEqual(PM5Constants.connectionInterval, 0.030)
    }
    
    func test_PM5Constants_connectionTimeout_shouldBe10s() throws {
        XCTAssertEqual(PM5Constants.connectionTimeout, 10.0)
    }
    
    func test_PM5Constants_defaultMTU_shouldBe23() throws {
        XCTAssertEqual(PM5Constants.defaultMTU, 23)
    }
    
    func test_PM5Constants_maxMTU_shouldBe512() throws {
        XCTAssertEqual(PM5Constants.maxMTU, 512)
    }
    
    func test_PM5Constants_sampleRates_shouldHaveCorrectValues() throws {
        XCTAssertEqual(PM5Constants.sampleRate1Second, 0)
        XCTAssertEqual(PM5Constants.sampleRate500ms, 1)
        XCTAssertEqual(PM5Constants.sampleRate250ms, 2)
        XCTAssertEqual(PM5Constants.sampleRate100ms, 3)
    }
    
    func test_PM5Constants_invalidHeartRate_shouldBe255() throws {
        XCTAssertEqual(PM5Constants.invalidHeartRate, 255)
    }
    
    // MARK: - Workout Type Enum Tests
    
    func test_WorkoutType_justRowNoSplits_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(WorkoutType.justRowNoSplits.rawValue, 0)
    }
    
    func test_WorkoutType_justRowSplits_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(WorkoutType.justRowSplits.rawValue, 1)
    }
    
    func test_WorkoutType_fixedDistNoSplits_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(WorkoutType.fixedDistNoSplits.rawValue, 2)
    }
    
    func test_WorkoutType_initFromRawValue_shouldWorkCorrectly() throws {
        XCTAssertEqual(WorkoutType(rawValue: 0), .justRowNoSplits)
        XCTAssertEqual(WorkoutType(rawValue: 5), .fixedTimeSplits)
        XCTAssertNil(WorkoutType(rawValue: 99))
    }
    
    // MARK: - Workout State Enum Tests
    
    func test_WorkoutState_waitToBegin_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(WorkoutState.waitToBegin.rawValue, 0)
    }
    
    func test_WorkoutState_workoutRow_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(WorkoutState.workoutRow.rawValue, 1)
    }
    
    func test_WorkoutState_workoutEnd_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(WorkoutState.workoutEnd.rawValue, 10)
    }
    
    func test_WorkoutState_initFromRawValue_shouldWorkCorrectly() throws {
        XCTAssertEqual(WorkoutState(rawValue: 0), .waitToBegin)
        XCTAssertEqual(WorkoutState(rawValue: 10), .workoutEnd)
        XCTAssertNil(WorkoutState(rawValue: 99))
    }
    
    // MARK: - Rowing State Enum Tests
    
    func test_RowingState_inactive_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(RowingState.inactive.rawValue, 0)
    }
    
    func test_RowingState_active_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(RowingState.active.rawValue, 1)
    }
    
    func test_RowingState_initFromRawValue_shouldWorkCorrectly() throws {
        XCTAssertEqual(RowingState(rawValue: 0), .inactive)
        XCTAssertEqual(RowingState(rawValue: 1), .active)
        XCTAssertNil(RowingState(rawValue: 2))
    }
    
    // MARK: - Stroke State Enum Tests
    
    func test_StrokeState_waitingForWheelToReachMinSpeed_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(StrokeState.waitingForWheelToReachMinSpeed.rawValue, 0)
    }
    
    func test_StrokeState_driving_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(StrokeState.driving.rawValue, 2)
    }
    
    func test_StrokeState_recovery_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(StrokeState.recovery.rawValue, 4)
    }
    
    func test_StrokeState_initFromRawValue_shouldWorkCorrectly() throws {
        XCTAssertEqual(StrokeState(rawValue: 0), .waitingForWheelToReachMinSpeed)
        XCTAssertEqual(StrokeState(rawValue: 4), .recovery)
        XCTAssertNil(StrokeState(rawValue: 99))
    }
    
    // MARK: - Interval Type Enum Tests
    
    func test_IntervalType_time_shouldHaveRawValue1() throws {
        XCTAssertEqual(IntervalType.time.rawValue, 1)
    }
    
    func test_IntervalType_time_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(IntervalType.time.rawValue, 1)
    }
    
    func test_IntervalType_none255_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(IntervalType.none255.rawValue, 255)
    }
    
    func test_IntervalType_initFromRawValue_shouldWorkCorrectly() throws {
        XCTAssertNil(IntervalType(rawValue: 0))
        XCTAssertEqual(IntervalType(rawValue: 255), .none255)
        XCTAssertNil(IntervalType(rawValue: 99))
    }
    
    // MARK: - Erg Machine Type Enum Tests
    
    func test_ErgMachineType_staticD_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(ErgMachineType.staticD.rawValue, 0)
    }
    
    func test_ErgMachineType_staticE_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(ErgMachineType.staticE.rawValue, 5)
    }
    
    func test_ErgMachineType_slidesD_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(ErgMachineType.slidesD.rawValue, 19)
    }
    
    func test_ErgMachineType_staticBike_shouldHaveCorrectRawValue() throws {
        XCTAssertEqual(ErgMachineType.staticBike.rawValue, 194)
    }
    
    func test_ErgMachineType_initFromRawValue_shouldWorkCorrectly() throws {
        XCTAssertEqual(ErgMachineType(rawValue: 0), .staticD)
        XCTAssertEqual(ErgMachineType(rawValue: 5), .staticE)
        XCTAssertEqual(ErgMachineType(rawValue: 194), .staticBike)
        XCTAssertNil(ErgMachineType(rawValue: 99))
    }
    
    // MARK: - Edge Cases
    
    func test_createUUID_withEmptyString_shouldNotCrash() throws {
        XCTAssertNoThrow(PM5ServiceUUIDs.createUUID(""))
    }
    
    func test_createUUID_withLongString_shouldNotCrash() throws {
        XCTAssertNoThrow(PM5ServiceUUIDs.createUUID("123456789"))
    }
}