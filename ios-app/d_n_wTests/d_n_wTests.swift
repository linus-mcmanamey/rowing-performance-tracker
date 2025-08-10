//
//  d_n_wTests.swift
//  d_n_wTests
//
//  Created by Linus McManamey on 5/8/2025.
//

import XCTest
@testable import d_n_w

class d_n_wTests: XCTestCase {
    override func setUpWithError() throws {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_example_whenCalled_shouldPass() throws {
        // ARRANGE
        let expectedValue = true
        
        // ACT
        let actualValue = true
        
        // ASSERT
        XCTAssertEqual(expectedValue, actualValue, "Example test should pass")
    }
    
    func test_appLaunch_whenInitialized_shouldHaveValidConfiguration() throws {
        // ARRANGE & ACT
        let app = d_n_wApp()
        
        // ASSERT
        XCTAssertNotNil(app, "App should initialize successfully")
    }
}
