//
//  MockPM5Service.swift
//  d_n_wTests
//
//  Created by Development Agent
//

import Foundation
import CoreBluetooth
import Combine
@testable import d_n_w

/// Protocol defining the PM5 service interface for dependency injection
protocol PM5ServiceProtocol: ObservableObject {
    var isConnected: Bool { get }
    var isScanning: Bool { get }
    var discoveredDevices: [CBPeripheral] { get }
    var rowingData: PM5RowingData { get }
    var deviceInfo: PM5DeviceInfo? { get }
    var connectionState: ConnectionState { get }
    var error: PM5Error? { get }
    var isMockMode: Bool { get }
    
    func startScanning()
    func stopScanning()
    func connect(to peripheral: CBPeripheral)
    func disconnect()
    func setSampleRate(_ rate: UInt8)
    func sendCSAFECommand(_ command: Data)
    func enableMockMode()
    func disableMockMode()
}

/// Mock PM5 service for testing without hardware dependency
@MainActor
class MockPM5Service: NSObject, ObservableObject, PM5ServiceProtocol {
    // MARK: - Published Properties
    @Published var isConnected = false
    @Published var isScanning = false
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var rowingData = PM5RowingData()
    @Published var deviceInfo: PM5DeviceInfo?
    @Published var connectionState: ConnectionState = .disconnected
    @Published var error: PM5Error?
    @Published var isMockMode = true
    
    // MARK: - Test Configuration Properties
    var shouldFailConnection = false
    var shouldFailScanning = false
    var connectionDelay: TimeInterval = 0.1
    var mockDeviceCount = 1
    var customRowingData: PM5RowingData?
    var customDeviceInfo: PM5DeviceInfo?
    var customError: PM5Error?
    
    // MARK: - Call Tracking for Test Verification
    internal(set) var startScanningCallCount = 0
    internal(set) var stopScanningCallCount = 0
    internal(set) var connectCallCount = 0
    internal(set) var disconnectCallCount = 0
    internal(set) var setSampleRateCallCount = 0
    internal(set) var sendCSAFECommandCallCount = 0
    internal(set) var enableMockModeCallCount = 0
    internal(set) var disableMockModeCallCount = 0
    
    private(set) var lastConnectedPeripheral: CBPeripheral?
    private(set) var lastSampleRate: UInt8?
    private(set) var lastCSAFECommand: Data?
    
    // MARK: - Private Properties
    private var mockTimer: Timer?
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupMockDeviceInfo()
        setupMockRowingData()
    }
    
    // MARK: - PM5ServiceProtocol Implementation
    
    func startScanning() {
        startScanningCallCount += 1
        
        guard !shouldFailScanning else {
            error = customError ?? .bluetoothNotAvailable
            return
        }
        
        isScanning = true
        error = nil
        
        // Simulate device discovery after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.simulateDeviceDiscovery()
        }
    }
    
    func stopScanning() {
        stopScanningCallCount += 1
        isScanning = false
        discoveredDevices.removeAll()
    }
    
    func connect(to peripheral: CBPeripheral) {
        connectCallCount += 1
        lastConnectedPeripheral = peripheral
        
        guard !shouldFailConnection else {
            error = customError ?? .connectionFailed
            connectionState = .disconnected
            return
        }
        
        connectionState = .connecting
        error = nil
        
        // Simulate connection after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + connectionDelay) { [weak self] in
            self?.completeConnection()
        }
    }
    
    func disconnect() {
        disconnectCallCount += 1
        isConnected = false
        connectionState = .disconnected
        lastConnectedPeripheral = nil
        stopMockDataGeneration()
    }
    
    func setSampleRate(_ rate: UInt8) {
        setSampleRateCallCount += 1
        lastSampleRate = rate
        
        // Mock implementation - no actual hardware communication
        if isConnected {
            // Restart mock data generation with new rate if connected
            stopMockDataGeneration()
            startMockDataGeneration()
        }
    }
    
    func sendCSAFECommand(_ command: Data) {
        sendCSAFECommandCallCount += 1
        lastCSAFECommand = command
        
        // Mock implementation - simulate command response
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.simulateCSAFEResponse(for: command)
        }
    }
    
    func enableMockMode() {
        enableMockModeCallCount += 1
        isMockMode = true
        startMockDataGeneration()
    }
    
    func disableMockMode() {
        disableMockModeCallCount += 1
        isMockMode = false
        stopMockDataGeneration()
    }
    
    // MARK: - Test Configuration Methods
    
    func reset() {
        // Reset all state for clean tests
        isConnected = false
        isScanning = false
        discoveredDevices.removeAll()
        connectionState = .disconnected
        error = nil
        shouldFailConnection = false
        shouldFailScanning = false
        connectionDelay = 0.1
        mockDeviceCount = 1
        customRowingData = nil
        customDeviceInfo = nil
        customError = nil
        
        // Reset call counts
        startScanningCallCount = 0
        stopScanningCallCount = 0
        connectCallCount = 0
        disconnectCallCount = 0
        setSampleRateCallCount = 0
        sendCSAFECommandCallCount = 0
        enableMockModeCallCount = 0
        disableMockModeCallCount = 0
        
        // Reset tracked values
        lastConnectedPeripheral = nil
        lastSampleRate = nil
        lastCSAFECommand = nil
        
        stopMockDataGeneration()
        setupMockDeviceInfo()
        setupMockRowingData()
    }
    
    // MARK: - Private Mock Implementation
    
    private func setupMockDeviceInfo() {
        deviceInfo = customDeviceInfo ?? PM5DeviceInfo(
            modelNumber: "PM5-TEST",
            serialNumber: "PM5-MOCK-12345",
            hardwareRevision: "1.0",
            firmwareRevision: "2.0",
            manufacturer: "Concept2 Mock",
            ergMachineType: .staticD,
            attMTU: 23,
            llDLE: 27
        )
    }
    
    private func setupMockRowingData() {
        rowingData = customRowingData ?? PM5RowingData()
    }
    
    private func simulateDeviceDiscovery() {
        guard isScanning else { return }
        
        discoveredDevices.removeAll()
        
        // Note: CBPeripheral cannot be initialized directly, so for testing purposes
        // we'll simulate device discovery without actually creating CBPeripheral instances.
        // In real usage, the mock service would track device count instead.
        print("Mock: Discovered \(mockDeviceCount) PM5 devices")
    }
    
    private func completeConnection() {
        isConnected = true
        connectionState = .connected
        stopScanning()
        startMockDataGeneration()
    }
    
    private func startMockDataGeneration() {
        stopMockDataGeneration()
        
        mockTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.generateMockData()
        }
    }
    
    private func stopMockDataGeneration() {
        mockTimer?.invalidate()
        mockTimer = nil
    }
    
    private func generateMockData() {
        let currentTime = Date().timeIntervalSince1970
        let elapsedTime = currentTime.truncatingRemainder(dividingBy: 60) // Reset every minute for testing
        
        // Generate realistic mock rowing data using proper PM5 data structure
        let generalStatus = GeneralStatus(
            elapsedTime: elapsedTime,
            distance: elapsedTime * 10, // 10m per second pace
            workoutType: .justRowNoSplits,
            intervalType: .none,
            workoutState: .workoutRow,
            rowingState: .active,
            strokeState: .waitingForWheelToReachMinSpeed,
            totalWorkDistance: elapsedTime * 10,
            workoutDuration: nil,
            workoutDurationType: nil,
            dragFactor: nil
        )
        
        let additionalStatus1 = AdditionalStatus1(
            elapsedTime: elapsedTime,
            speed: 5.0 + sin(elapsedTime / 10) * 1.0, // Varying speed
            strokeRate: UInt8(20 + sin(elapsedTime / 10) * 5), // Varying stroke rate 15-25
            heartRate: UInt8(140 + sin(elapsedTime / 25) * 20), // Varying HR 120-160
            currentPace: 120 + sin(elapsedTime / 15) * 20, // Varying pace
            averagePace: 120,
            restDistance: 0,
            restTime: 0,
            ergMachineType: .staticD
        )
        
        let additionalStatus2 = AdditionalStatus2(
            elapsedTime: elapsedTime,
            intervalCount: 1,
            averagePower: UInt16(200 + sin(elapsedTime / 20) * 50), // Varying power 150-250W
            totalCalories: UInt16(elapsedTime / 10), // 1 calorie per 10 seconds
            splitIntervalAvgPace: 120,
            splitIntervalAvgPower: UInt16(200),
            splitIntervalAvgCalories: 300,
            lastSplitTime: 0,
            lastSplitDistance: 0
        )
        
        rowingData.generalStatus = generalStatus
        rowingData.additionalStatus1 = additionalStatus1
        rowingData.additionalStatus2 = additionalStatus2
        rowingData.lastUpdate = Date()
    }
    
    private func simulateCSAFEResponse(for command: Data) {
        // Mock CSAFE command responses for testing
        // This is a simplified implementation - real implementation would parse commands
        
        if !command.isEmpty {
            // Simulate successful command acknowledgment
            // In real implementation, this would generate proper CSAFE response data
            // For testing, we just ensure no errors are generated
            error = nil
        }
    }
}
