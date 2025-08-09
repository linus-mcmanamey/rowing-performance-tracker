# Testing Strategy

## iOS Testing (80% Coverage Target)

### Unit Tests
```swift
class PM5ControllerTests: XCTestCase {
    func testCSAFEFrameParsing() {
        let testData = Data([0xF1, 0x31, 0x00, 0x10, ...])
        let result = CSAFEParser.parse(testData)
        
        XCTAssertEqual(result.distance, 1234.5)
        XCTAssertEqual(result.strokeRate, 24)
    }
    
    func testDeviceCompatibility() {
        // Test on simulated older device capabilities
        let lowMemoryCapabilities = DeviceCapabilities(memoryTier: .low)
        let viewModel = SessionViewModel(capabilities: lowMemoryCapabilities)
        
        XCTAssertEqual(viewModel.maxDataPoints, 300)
        XCTAssertEqual(viewModel.updateInterval, 1.0)
    }
}
```

### Device Compatibility Tests
```swift
class DeviceCompatibilityTests: XCTestCase {
    func testPerformanceOnOlderDevices() {
        // Simulate iPhone 6s capabilities
        let capabilities = DeviceCapabilities(
            supportsAdvancedGraphics: false,
            memoryTier: .low
        )
        
        let visualizer = PerformanceVisualizer(capabilities: capabilities)
        // Should use simplified metrics view
        XCTAssertTrue(visualizer.usesSimplifiedView)
    }
}
```

## Backend Testing
```typescript
describe('Sessions API', () => {
  test('POST /api/sessions creates session', async () => {
    const response = await request(app)
      .post('/api/sessions')
      .send(mockSessionData)
      .expect(201);
    
    expect(response.body).toHaveProperty('sessionId');
  });
});
```
