//
//  PM5ControllerTests.swift
//  d_n_wTests
//
//  Created by Development Agent
//

import XCTest
import CoreBluetooth
import Combine
@testable import d_n_w

@MainActor
class PM5ControllerTests: XCTestCase {
    private var controller: PM5Controller!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        super.setUp()
        controller = PM5Controller()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        cancellables?.removeAll()
        controller = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_init_shouldSetDefaultValues() throws {
        XCTAssertFalse(controller.isConnected)
        XCTAssertFalse(controller.isScanning)
        XCTAssertTrue(controller.discoveredDevices.isEmpty)
        XCTAssertEqual(controller.connectionState, .disconnected)
        XCTAssertNil(controller.error)
        XCTAssertFalse(controller.isMockMode)
        XCTAssertNotNil(controller.rowingData)
        XCTAssertNil(controller.deviceInfo)
    }
    
    // MARK: - Mock Mode Tests
    
    func test_enableMockMode_shouldSetMockModeProperties() throws {
        // ARRANGE
        XCTAssertFalse(controller.isMockMode)
        XCTAssertFalse(controller.isConnected)
        XCTAssertEqual(controller.connectionState, .disconnected)
        
        // ACT
        controller.enableMockMode()
        
        // ASSERT
        XCTAssertTrue(controller.isMockMode)
        XCTAssertTrue(controller.isConnected)
        XCTAssertEqual(controller.connectionState, .connected)
        XCTAssertNotNil(controller.deviceInfo)
        XCTAssertEqual(controller.deviceInfo?.modelNumber, "Model D/E")
        XCTAssertEqual(controller.deviceInfo?.manufacturer, "Concept2")
    }
    
    func test_disableMockMode_shouldResetMockModeProperties() throws {
        // ARRANGE
        controller.enableMockMode()
        XCTAssertTrue(controller.isMockMode)
        XCTAssertTrue(controller.isConnected)
        
        // ACT
        controller.disableMockMode()
        
        // ASSERT
        XCTAssertFalse(controller.isMockMode)
        XCTAssertFalse(controller.isConnected)
        XCTAssertEqual(controller.connectionState, .disconnected)
    }
    
    func test_mockMode_shouldGenerateRowingData() throws {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Mock data should be generated")
        let initialUpdateTime = controller.rowingData.lastUpdate
        
        controller.$rowingData
            .dropFirst() // Skip initial value
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // ACT
        controller.enableMockMode()
        
        // ASSERT
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotEqual(controller.rowingData.lastUpdate, initialUpdateTime)
        XCTAssertNotNil(controller.rowingData.generalStatus)
        XCTAssertNotNil(controller.rowingData.strokeData)
        XCTAssertNotNil(controller.rowingData.additionalStatus1)
    }
    
    // MARK: - Connection State Tests
    
    func test_connectionState_shouldPublishChanges() throws {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Connection state should change")
        var receivedStates: [ConnectionState] = []
        
        controller.$connectionState
            .sink { state in
                receivedStates.append(state)
                if receivedStates.count == 2 { // Initial + one change
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // ACT
        controller.enableMockMode()
        
        // ASSERT
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedStates.first, .disconnected)
        XCTAssertEqual(receivedStates.last, .connected)
    }
    
    // MARK: - Error Handling Tests
    
    func test_error_shouldBeNilInitially() throws {
        XCTAssertNil(controller.error)
    }
    
    // MARK: - Rowing Data Tests
    
    func test_rowingData_shouldHaveInitialValues() throws {
        XCTAssertNotNil(controller.rowingData)
        XCTAssertNil(controller.rowingData.lastUpdate)
        XCTAssertNil(controller.rowingData.generalStatus)
        XCTAssertNil(controller.rowingData.additionalStatus1)
        XCTAssertNil(controller.rowingData.additionalStatus2)
    }
    
    func test_mockRowingData_shouldHaveRealisticValues() throws {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Mock data should be realistic")
        
        controller.$rowingData
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // ACT
        controller.enableMockMode()
        
        // ASSERT
        wait(for: [expectation], timeout: 1.0)
        
        if let generalStatus = controller.rowingData.generalStatus {
            XCTAssertGreaterThanOrEqual(generalStatus.elapsedTime, 0)
            XCTAssertEqual(generalStatus.workoutType, .justRowNoSplits)
            XCTAssertEqual(generalStatus.rowingState, .active)
        }
        
        if let strokeData = controller.rowingData.strokeData {
            XCTAssertGreaterThan(strokeData.driveLength, 0)
            XCTAssertGreaterThan(strokeData.workPerStroke, 0)
        }
        
        if let additionalStatus1 = controller.rowingData.additionalStatus1 {
            XCTAssertGreaterThan(additionalStatus1.speed, 0)
            XCTAssertGreaterThan(additionalStatus1.strokeRate, 0)
            XCTAssertGreaterThan(additionalStatus1.currentPace, 0)
        }
    }
    
    // MARK: - Device Discovery Tests
    
    func test_discoveredDevices_shouldBeEmptyInitially() throws {
        XCTAssertTrue(controller.discoveredDevices.isEmpty)
    }
    
    // MARK: - Sample Rate Tests
    
    func test_setSampleRate_shouldAcceptValidRate() throws {
        // This test verifies the method doesn't crash with valid input
        // Since we can't easily test BLE communication in unit tests,
        // we just verify the method can be called without error
        XCTAssertNoThrow(controller.setSampleRate(PM5Constants.sampleRate250ms))
        XCTAssertNoThrow(controller.setSampleRate(PM5Constants.sampleRate500ms))
        XCTAssertNoThrow(controller.setSampleRate(PM5Constants.sampleRate1Second))
    }
    
    // MARK: - CSAFE Command Tests
    
    func test_sendCSAFECommand_shouldAcceptValidCommand() throws {
        // This test verifies the method doesn't crash with valid input
        let testCommand = Data([0x01, 0x02, 0x03])
        XCTAssertNoThrow(controller.sendCSAFECommand(testCommand))
    }
    
    func test_sendCSAFECommand_shouldAcceptEmptyCommand() throws {
        // This test verifies the method handles empty data gracefully
        let emptyCommand = Data()
        XCTAssertNoThrow(controller.sendCSAFECommand(emptyCommand))
    }
}