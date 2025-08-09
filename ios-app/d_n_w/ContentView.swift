//
//  ContentView.swift
//  Rowing Performance Tracker
//
//  Created by Development Team on 8/9/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            PM5TestView()
                .tabItem {
                    Image(systemName: "figure.rowing")
                    Text("PM5")
                }
            
            PerformanceView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Performance")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "figure.rowing")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Rowing Performance Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Connect • Track • Improve")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Quick Actions
                VStack(spacing: 20) {
                    NavigationLink(destination: PM5TestView()) {
                        HStack {
                            Image(systemName: "bluetooth")
                                .font(.title2)
                            Text("Connect to PM5")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: PerformanceView()) {
                        HStack {
                            Image(systemName: "chart.bar")
                                .font(.title2)
                            Text("View Performance")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Status Section
                VStack(spacing: 10) {
                    Text("Status")
                        .font(.headline)
                    
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                        Text("PM5 Disconnected")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct PerformanceView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Performance Analytics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Your rowing performance data will appear here once you start tracking workouts.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 100))
                    .foregroundColor(.gray.opacity(0.3))
                
                Spacer()
            }
            .navigationTitle("Performance")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section("App") {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Bluetooth") {
                    HStack {
                        Image(systemName: "bluetooth")
                        Text("Auto-connect to PM5")
                        Spacer()
                        Toggle("", isOn: .constant(true))
                    }
                }
                
                Section("Data") {
                    HStack {
                        Image(systemName: "icloud")
                        Text("Sync with Cloud")
                        Spacer()
                        Text("Coming Soon")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ContentView()
}
