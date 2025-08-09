//
//  PM5TestView.swift
//  d_n_w
//
//  Test view for PM5 BLE communication
//

import SwiftUI
import CoreBluetooth

struct PM5TestView: View {
    @StateObject private var pm5Controller = PM5Controller()
    @State private var selectedPeripheral: CBPeripheral?
    @State private var showingWorkoutOptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Connection Status
                connectionStatusSection
                
                // Device List
                if pm5Controller.isScanning || !pm5Controller.discoveredDevices.isEmpty {
                    deviceListSection
                }
                
                // Rowing Data
                if pm5Controller.isConnected {
                    rowingDataSection
                    
                    // Control Buttons
                    controlButtonsSection
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("PM5 Test")
            .alert("Error", isPresented: .constant(pm5Controller.error != nil)) {
                Button("OK") {
                    pm5Controller.error = nil
                }
            } message: {
                Text(pm5Controller.error?.localizedDescription ?? "Unknown error")
            }
            .sheet(isPresented: $showingWorkoutOptions) {
                workoutOptionsSheet
            }
        }
    }
    
    // MARK: - View Components
    
    private var connectionStatusSection: some View {
        VStack(spacing: 12) {
            HStack {
                Circle()
                    .fill(connectionStatusColor)
                    .frame(width: 12, height: 12)
                Text(connectionStatusText)
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button(pm5Controller.isScanning ? "Stop Scan" : "Scan") {
                    if pm5Controller.isScanning {
                        pm5Controller.stopScanning()
                    } else {
                        pm5Controller.startScanning()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(pm5Controller.connectionState == .connecting)
                
                if pm5Controller.isConnected {
                    Button("Disconnect") {
                        pm5Controller.disconnect()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var deviceListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Discovered Devices")
                .font(.headline)
            
            if pm5Controller.discoveredDevices.isEmpty {
                if pm5Controller.isScanning {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Scanning for PM5 devices...")
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("No devices found")
                        .foregroundColor(.secondary)
                }
            } else {
                ForEach(pm5Controller.discoveredDevices, id: \.identifier) { peripheral in
                    DeviceRow(peripheral: peripheral) {
                        pm5Controller.connect(to: peripheral)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var rowingDataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rowing Data")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                DataCard(title: "Distance", value: formatDistance(pm5Controller.rowingData.distance))
                DataCard(title: "Time", value: formatTime(pm5Controller.rowingData.elapsedTime))
                DataCard(title: "Pace", value: formatPace(pm5Controller.rowingData.currentPace))
                DataCard(title: "SPM", value: formatStrokeRate(pm5Controller.rowingData.strokeRate))
                DataCard(title: "HR", value: formatHeartRate(pm5Controller.rowingData.heartRate))
                DataCard(title: "Calories", value: formatCalories(pm5Controller.rowingData.calories))
            }
            
            // Workout State
            if let workoutState = pm5Controller.rowingData.generalStatus?.workoutState {
                HStack {
                    Text("Workout State:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(workoutStateText(workoutState))
                        .font(.caption)
                        .fontWeight(.medium)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var controlButtonsSection: some View {
        VStack(spacing: 12) {
            Text("Workout Controls")
                .font(.headline)
            
            HStack(spacing: 12) {
                Button("Just Row") {
                    pm5Controller.startJustRowWorkout()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Start Workout") {
                    showingWorkoutOptions = true
                }
                .buttonStyle(.bordered)
                
                Button("Status") {
                    pm5Controller.requestPM5Status()
                }
                .buttonStyle(.bordered)
            }
            
            HStack(spacing: 12) {
                Button("Sample Rate: 1s") {
                    pm5Controller.setSampleRate(PM5Constants.sampleRate1Second)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button("Sample Rate: 500ms") {
                    pm5Controller.setSampleRate(PM5Constants.sampleRate500ms)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button("Sample Rate: 250ms") {
                    pm5Controller.setSampleRate(PM5Constants.sampleRate250ms)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var workoutOptionsSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("2000m Distance") {
                    pm5Controller.startDistanceWorkout(meters: 2000)
                    showingWorkoutOptions = false
                }
                .buttonStyle(.borderedProminent)
                
                Button("5000m Distance") {
                    pm5Controller.startDistanceWorkout(meters: 5000)
                    showingWorkoutOptions = false
                }
                .buttonStyle(.borderedProminent)
                
                Button("20 Minute Time") {
                    pm5Controller.startTimeWorkout(minutes: 20, seconds: 0)
                    showingWorkoutOptions = false
                }
                .buttonStyle(.borderedProminent)
                
                Button("30 Minute Time") {
                    pm5Controller.startTimeWorkout(minutes: 30, seconds: 0)
                    showingWorkoutOptions = false
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        showingWorkoutOptions = false
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var connectionStatusColor: Color {
        switch pm5Controller.connectionState {
        case .disconnected:
            return .red
        case .connecting, .disconnecting:
            return .orange
        case .connected:
            return .green
        }
    }
    
    private var connectionStatusText: String {
        switch pm5Controller.connectionState {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting..."
        case .connected:
            return "Connected"
        case .disconnecting:
            return "Disconnecting..."
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDistance(_ distance: Double?) -> String {
        guard let distance = distance else { return "--" }
        return String(format: "%.0fm", distance)
    }
    
    private func formatTime(_ time: TimeInterval?) -> String {
        guard let time = time else { return "--:--" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func formatPace(_ pace: TimeInterval?) -> String {
        guard let pace = pace else { return "--:--" }
        let minutes = Int(pace) / 60
        let seconds = Int(pace) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func formatStrokeRate(_ spm: UInt8?) -> String {
        guard let spm = spm else { return "--" }
        return "\(spm)"
    }
    
    private func formatHeartRate(_ hr: UInt8?) -> String {
        guard let hr = hr else { return "--" }
        return "\(hr)"
    }
    
    private func formatCalories(_ calories: UInt16?) -> String {
        guard let calories = calories else { return "--" }
        return "\(calories)"
    }
    
    private func workoutStateText(_ state: WorkoutState) -> String {
        switch state {
        case .waitToBegin:
            return "Wait to Begin"
        case .workoutRow:
            return "Rowing"
        case .countdownPause:
            return "Countdown"
        case .intervalRest:
            return "Rest"
        case .intervalWorkTime:
            return "Work (Time)"
        case .intervalWorkDistance:
            return "Work (Distance)"
        case .workoutEnd:
            return "Finished"
        case .terminate:
            return "Terminated"
        case .workoutLogged:
            return "Logged"
        case .rearm:
            return "Ready"
        }
    }
}

// MARK: - Supporting Views

struct DeviceRow: View {
    let peripheral: CBPeripheral
    let onConnect: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(peripheral.name ?? "Unknown PM5")
                    .font(.headline)
                Text(peripheral.identifier.uuidString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Connect") {
                onConnect()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(.vertical, 4)
    }
}

struct DataCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    PM5TestView()
}