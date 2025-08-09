//
//  PM5Controller.swift
//  d_n_w
//
//  PM5 BLE Controller
//

import Foundation
import CoreBluetooth
import Combine

@MainActor
class PM5Controller: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var isConnected = false
    @Published var isScanning = false
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var rowingData = PM5RowingData()
    @Published var deviceInfo: PM5DeviceInfo?
    @Published var connectionState: ConnectionState = .disconnected
    @Published var error: PM5Error?
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var characteristics: [CBUUID: CBCharacteristic] = [:]
    private var sampleRate: UInt8 = PM5Constants.sampleRate500ms
    
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
        guard centralManager.state == .poweredOn else {
            error = .bluetoothNotAvailable
            return
        }
        
        discoveredDevices.removeAll()
        isScanning = true
        
        let serviceUUIDs = [
            PM5ServiceUUIDs.deviceInformation,
            PM5ServiceUUIDs.rowing
        ]
        
        centralManager.scanForPeripherals(
            withServices: serviceUUIDs,
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        )
    }
    
    /// Stop scanning for devices
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
    }
    
    /// Connect to a PM5 device
    func connect(to peripheral: CBPeripheral) {
        stopScanning()
        connectionState = .connecting
        connectedPeripheral = peripheral
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    /// Disconnect from the current device
    func disconnect() {
        guard let peripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
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
                print("Workout completed: \(summary.distance)m in \(summary.elapsedTime)s")
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
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
        case .poweredOff:
            error = .bluetoothNotAvailable
            print("Bluetooth is powered off")
        case .unauthorized:
            error = .bluetoothNotAvailable
            print("Bluetooth access unauthorized")
        case .unsupported:
            error = .bluetoothNotAvailable
            print("Bluetooth not supported")
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Check if this is a PM5 device
        if let name = peripheral.name, name.hasPrefix(PM5Constants.deviceNamePrefix) {
            if !discoveredDevices.contains(peripheral) {
                discoveredDevices.append(peripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectionState = .connected
        isConnected = true
        
        // Discover services
        let serviceUUIDs = [
            PM5ServiceUUIDs.deviceInformation,
            PM5ServiceUUIDs.control,
            PM5ServiceUUIDs.rowing
        ]
        
        peripheral.discoverServices(serviceUUIDs)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectionState = .disconnected
        self.error = .connectionFailed
        clearConnection()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectionState = .disconnected
        clearConnection()
    }
}

// MARK: - CBPeripheralDelegate
extension PM5Controller: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
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
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
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
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            self.error = .dataParsingFailed
            return
        }
        
        handleCharacteristicUpdate(characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Write error: \(error)")
            self.error = .commandFailed
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Notification setup error: \(error)")
        } else {
            print("Notifications enabled for \(characteristic.uuid)")
        }
    }
}