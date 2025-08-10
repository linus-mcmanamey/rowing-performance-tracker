//
//  PM5ServiceProtocol.swift
//  d_n_w
//
//  Created by Development Agent
//

import Foundation
import CoreBluetooth
import Combine

/// Protocol defining the PM5 service interface for dependency injection and testing
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
