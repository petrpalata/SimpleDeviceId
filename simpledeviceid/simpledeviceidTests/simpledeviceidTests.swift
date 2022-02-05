//
//  SimpleDeviceIdTests.swift
//  SimpleDeviceIdTests
//

import XCTest
@testable import SimpleDeviceId

class SimpleDeviceIdTests: XCTestCase {
    // MARK: Dependencies
    var sut: SimpleDeviceId!
    
    // MARK: Test Lifecycle
    override func setUp() {
        sut = SimpleDeviceId()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    // MARK: getDeviceId
    func testGetDeviceIdReturnsValue() {
        let deviceId = sut.getDeviceId()
        XCTAssertNotNil(deviceId)
    }
}
