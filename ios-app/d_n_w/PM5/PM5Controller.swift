//
//  PM5Controller.swift
//  d_n_w
//
//  PM5 BLE Controller
//

import Foundation
import CoreBluetooth
import Combine
import os

@MainActor
class PM5Controller: NSObject, ObservableObject, PM5ServiceProtocol {
    // MARK: - Published Properties
    @Published var isConnected = false
    @Published var isScanning = false
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var rowingData = PM5RowingData()
    @Published var deviceInfo: PM5DeviceInfo?
    @Published var connectionState: ConnectionState = .disconnected
    @Published var error: PM5Error?
    @Published var isMockMode = false
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    private var characteristics: [CBUUID: CBCharacteristic] = [:]
    private var sampleRate: UInt8 = PM5Constants.sampleRate500ms
    private var mockDataTimer: Timer?
    private let logger = Logger(subsystem: "com.d_n_w.PM5", category: "PM5Controller")
    
    // Service references
    private var deviceInfoService: CBService?
    private var controlService: CBService?
    private var rowingService: CBService?
    
    // MARK: - Initialization
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Public Methods
    
    /// Start scanning for PM5 devices
    func startScanning() {
        guard let centralManager = centralManager, centralManager.state == .poweredOn else {
            error = .bluetoothNotAvailable
            return
        }
        
        discoveredDevices.removeAll()
        isScanning = true
        
        // Scan for all devices - PM5s may not advertise specific services
        // We'll filter by name and services during discovery
        centralManager.scanForPeripherals(
            withServices: nil, // Scan for ALL devices
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        )
    }
    
    /// Stop scanning for devices
    func stopScanning() {
        centralManager?.stopScan()
        isScanning = false
    }
    
    /// Connect to a PM5 device
    func connect(to peripheral: CBPeripheral) {
        stopScanning()
        connectionState = .connecting
        connectedPeripheral = peripheral
        peripheral.delegate = self
        centralManager?.connect(peripheral, options: nil)
    }
    
    /// Disconnect from the current device
    func disconnect() {
        guard let peripheral = connectedPeripheral else { return }
        centralManager?.cancelPeripheralConnection(peripheral)
        connectionState = .disconnecting
    }
    
    /// Set the sample rate for data updates
    func setSampleRate(_ rate: UInt8) {
        guard let characteristic = characteristics[RowingCharacteristicUUIDs.sampleRateControl] else {
            return
        }
        
        sampleRate = rate
        let data = Data([rate])
        connectedPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    /// Send CSAFE command
    func sendCSAFECommand(_ command: Data) {
        guard let characteristic = characteristics[ControlCharacteristicUUIDs.pmReceive] else {
            return
        }
        
        connectedPeripheral?.writeValue(command, for: characteristic, type: .withResponse)
    }
    
    // MARK: - Private Methods
    
    private func setupNotifications() {
        let notificationCharacteristics: [CBUUID] = [
            RowingCharacteristicUUIDs.generalStatus,
            RowingCharacteristicUUIDs.additionalStatus1,
            RowingCharacteristicUUIDs.additionalStatus2,
            RowingCharacteristicUUIDs.strokeData,
            RowingCharacteristicUUIDs.additionalStrokeData,
            RowingCharacteristicUUIDs.splitIntervalData,
            RowingCharacteristicUUIDs.endOfWorkoutSummary,
            RowingCharacteristicUUIDs.heartRateBeltInfo
        ]
        
        for uuid in notificationCharacteristics {
            if let characteristic = characteristics[uuid] {
                connectedPeripheral?.setNotifyValue(true, for: characteristic)
            }
        }
        
        // Set default sample rate
        setSampleRate(sampleRate)
    }
    
    private func handleCharacteristicUpdate(_ characteristic: CBCharacteristic) {
        guard let data = characteristic.value else { return }
        
        switch characteristic.uuid {
        case RowingCharacteristicUUIDs.generalStatus:
            if let status = PM5DataParser.parseGeneralStatus(data) {
                rowingData.generalStatus = status
            }
            
        case RowingCharacteristicUUIDs.additionalStatus1:
            if let status = PM5DataParser.parseAdditionalStatus1(data) {
                rowingData.additionalStatus1 = status
            }
            
        case RowingCharacteristicUUIDs.additionalStatus2:
            if let status = PM5DataParser.parseAdditionalStatus2(data) {
                rowingData.additionalStatus2 = status
            }
            
        case RowingCharacteristicUUIDs.strokeData:
            if let stroke = PM5DataParser.parseStrokeData(data) {
                rowingData.strokeData = stroke
            }
            
        case RowingCharacteristicUUIDs.additionalStrokeData:
            if let stroke = PM5DataParser.parseAdditionalStrokeData(data) {
                rowingData.additionalStrokeData = stroke
            }
            
        case RowingCharacteristicUUIDs.splitIntervalData:
            if let split = PM5DataParser.parseSplitIntervalData(data) {
                rowingData.splitIntervalData = split
            }
            
        case RowingCharacteristicUUIDs.endOfWorkoutSummary:
            if let summary = PM5DataParser.parseEndOfWorkoutSummary(data) {
                // Handle workout end
                logger.info("Workout completed: \(summary.distance)m in \(summary.elapsedTime)s")
            }
            
        case RowingCharacteristicUUIDs.heartRateBeltInfo:
            if let hrInfo = PM5DataParser.parseHeartRateBeltInfo(data) {
                rowingData.heartRateBeltInfo = hrInfo
            }
            
        case RowingCharacteristicUUIDs.multiplexedInfo:
            if let (identifier, multiplex) = PM5DataParser.parseMultiplexedInfo(data) {
                // Handle multiplexed data based on identifier
                handleMultiplexedData(identifier: identifier, data: multiplex)
            }
            
        default:
            break
        }
        
        rowingData.lastUpdate = Date()
    }
    
    private func handleMultiplexedData(identifier: UInt8, data: Data) {
        // Map identifier to characteristic UUID and parse accordingly
        switch identifier {
        case 0x31:  // General Status
            if let status = PM5DataParser.parseGeneralStatus(data) {
                rowingData.generalStatus = status
            }
        case 0x32:  // Additional Status 1
            if let status = PM5DataParser.parseAdditionalStatus1(data) {
                rowingData.additionalStatus1 = status
            }
        case 0x33:  // Additional Status 2  
            if let status = PM5DataParser.parseAdditionalStatus2(data) {
                rowingData.additionalStatus2 = status
            }
        default:
            break
        }
    }
    
    private func readDeviceInformation() {
        let deviceInfoCharacteristics: [CBUUID] = [
            DeviceInfoCharacteristicUUIDs.modelNumber,
            DeviceInfoCharacteristicUUIDs.serialNumber,
            DeviceInfoCharacteristicUUIDs.hardwareRevision,
            DeviceInfoCharacteristicUUIDs.firmwareRevision,
            DeviceInfoCharacteristicUUIDs.manufacturer,
            DeviceInfoCharacteristicUUIDs.ergMachineType
        ]
        
        for uuid in deviceInfoCharacteristics {
            if let characteristic = characteristics[uuid] {
                connectedPeripheral?.readValue(for: characteristic)
            }
        }
    }
    
    private func clearConnection() {
        connectedPeripheral = nil
        characteristics.removeAll()
        deviceInfoService = nil
        controlService = nil
        rowingService = nil
        rowingData = PM5RowingData()
        deviceInfo = nil
        isConnected = false
        stopMockMode()
    }
    
    // MARK: - Mock PM5 Methods
    
    /// Enable mock PM5 mode for development/testing
    func enableMockMode() {
        isMockMode = true
        connectionState = .connected
        isConnected = true
        
        // Set mock device info
        deviceInfo = PM5DeviceInfo(
            modelNumber: "Model D/E",
            serialNumber: "PM5-MOCK-001",
            hardwareRevision: "633",
            firmwareRevision: "163",
            manufacturer: "Concept2",
            ergMachineType: .staticD,
            attMTU: 23,
            llDLE: 27
        )
        
        startMockDataSimulation()
        logger.info("Mock PM5 mode enabled")
    }
    
    /// Disable mock PM5 mode
    func disableMockMode() {
        isMockMode = false
        stopMockMode()
        connectionState = .disconnected
        isConnected = false
        logger.info("Mock PM5 mode disabled")
    }
    
    private func stopMockMode() {
        mockDataTimer?.invalidate()
        mockDataTimer = nil
    }
    
    private func startMockDataSimulation() {
        mockDataTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.generateMockRowingData()
            }
        }
    }
    
    private func generateMockRowingData() {
        // Simulate rowing data changes over time
        let elapsedTime = UInt32(Date().timeIntervalSince1970) % 3600 // Reset every hour
        let stroke = elapsedTime / 2 // One stroke every 2 seconds
        
        // Mock general status
        rowingData.generalStatus = GeneralStatus(
            elapsedTime: TimeInterval(elapsedTime),
            distance: Double(stroke * 10), // 10m per stroke
            workoutType: .justRowNoSplits,
            intervalType: nil,
            workoutState: .workoutRow,
            rowingState: .active,
            strokeState: .recovery,
            totalWorkDistance: Double(stroke * 10),
            workoutDuration: TimeInterval(elapsedTime),
            workoutDurationType: 0,
            dragFactor: 120
        )
        
        // Mock stroke data
        rowingData.strokeData = StrokeData(
            elapsedTime: TimeInterval(elapsedTime),
            distance: Double(stroke * 10),
            driveLength: 1.45,
            driveTime: 0.80,
            recoveryTime: 1.20,
            strokeDistance: 10.0,
            peakDriveForce: 45.0,
            averageDriveForce: 28.0,
            workPerStroke: 350.0,
            strokeCount: UInt16(stroke)
        )
        
        // Mock additional status with varying pace and power
        let pace = TimeInterval(120 + sin(Double(elapsedTime) / 10) * 20) // Varying pace 100-140 s/500m
        let power = UInt16(200 + sin(Double(elapsedTime) / 15) * 50) // Varying power 150-250W
        
        rowingData.additionalStatus1 = AdditionalStatus1(
            elapsedTime: TimeInterval(elapsedTime),
            speed: Double(500.0 / pace), // Convert pace to m/s
            strokeRate: UInt8(20 + sin(Double(elapsedTime) / 20) * 8), // 12-28 SPM
            heartRate: UInt8(140 + sin(Double(elapsedTime) / 30) * 20), // 120-160 BPM
            currentPace: pace,
            averagePace: pace + 5,
            restDistance: 0,
            restTime: 0,
            ergMachineType: .staticD
        )
        
        rowingData.lastUpdate = Date()
    }
}

// MARK: - Connection State
enum ConnectionState {
    case disconnected
    case connecting
    case connected
    case disconnecting
}

// MARK: - PM5 Errors
enum PM5Error: LocalizedError {
    case bluetoothNotAvailable
    case connectionFailed
    case serviceDiscoveryFailed
    case characteristicDiscoveryFailed
    case dataParsingFailed
    case commandFailed
    
    var errorDescription: String? {
        switch self {
        case .bluetoothNotAvailable:
            return "Bluetooth is not available"
        case .connectionFailed:
            return "Failed to connect to PM5"
        case .serviceDiscoveryFailed:
            return "Failed to discover PM5 services"
        case .characteristicDiscoveryFailed:
            return "Failed to discover PM5 characteristics"
        case .dataParsingFailed:
            return "Failed to parse PM5 data"
        case .commandFailed:
            return "Failed to send command to PM5"
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension PM5Controller: CBCentralManagerDelegate {
    nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Task { @MainActor in
            switch central.state {
            case .poweredOn:
                logger.info("Bluetooth is powered on")
            case .poweredOff:
                error = .bluetoothNotAvailable
                logger.warning("Bluetooth is powered off")
            case .unauthorized:
                error = .bluetoothNotAvailable
                logger.warning("Bluetooth access unauthorized")
            case .unsupported:
                error = .bluetoothNotAvailable
                logger.error("Bluetooth not supported")
            default:
                break
            }
        }
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        Task { @MainActor in
            // DEBUG: Show all discovered devices
            logger.debug("Discovered: \(peripheral.name ?? "Unknown") (RSSI: \(RSSI))")
            
            // Check if this is a PM5 device - handle both "PM5" and "PM5 [number] Row" patterns
            if let name = peripheral.name {
                let isPM5 = name.hasPrefix(PM5Constants.deviceNamePrefix) || 
                           (name.contains("PM5") && name.contains("Row"))
                
                if isPM5 {
                    if !discoveredDevices.contains(peripheral) {
                        discoveredDevices.append(peripheral)
                        logger.info("Added PM5 device: \(name)")
                    }
                }
            }
        }
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Task { @MainActor in
            connectionState = .connected
            isConnected = true
        }
        
        // Discover services
        let serviceUUIDs = [
            PM5ServiceUUIDs.deviceInformation,
            PM5ServiceUUIDs.control,
            PM5ServiceUUIDs.rowing
        ]
        
        peripheral.discoverServices(serviceUUIDs)
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Task { @MainActor in
            connectionState = .disconnected
            self.error = .connectionFailed
            clearConnection()
        }
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Task { @MainActor in
            connectionState = .disconnected
            clearConnection()
        }
    }
}

// MARK: - CBPeripheralDelegate
extension PM5Controller: CBPeripheralDelegate {
    nonisolated func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        Task { @MainActor in
            guard error == nil else {
                self.error = .serviceDiscoveryFailed
                return
            }
            
            guard let services = peripheral.services else { return }
            
            for service in services {
                switch service.uuid {
                case PM5ServiceUUIDs.deviceInformation:
                    deviceInfoService = service
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                case PM5ServiceUUIDs.control:
                    controlService = service
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                case PM5ServiceUUIDs.rowing:
                    rowingService = service
                    peripheral.discoverCharacteristics(nil, for: service)
                    
                default:
                    break
                }
            }
        }
    }
    
    nonisolated func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        Task { @MainActor in
            guard error == nil else {
                self.error = .characteristicDiscoveryFailed
                return
            }
            
            guard let characteristics = service.characteristics else { return }
            
            for characteristic in characteristics {
                self.characteristics[characteristic.uuid] = characteristic
            }
            
            // Check if all services have been discovered
            let requiredServices = [deviceInfoService, controlService, rowingService]
            if requiredServices.allSatisfy({ $0 != nil }) {
                // All services discovered, set up notifications and read device info
                setupNotifications()
                readDeviceInformation()
            }
        }
    }
    
    nonisolated func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        Task { @MainActor in
            guard error == nil else {
                self.error = .dataParsingFailed
                return
            }
            
            handleCharacteristicUpdate(characteristic)
        }
    }
    
    nonisolated func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        Task { @MainActor in
            if let error = error {
                logger.error("Write error: \(error)")
                self.error = .commandFailed
            }
        }
    }
    
    nonisolated func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            logger.error("Notification setup error: \(error)")
        } else {
            logger.debug("Notifications enabled for \(characteristic.uuid)")
        }
    }
}
