//
//  SimpleDeviceIdTests.swift
//  SimpleDeviceIdTests
//

import XCTest
@testable import SimpleDeviceId

class SimpleDeviceIdTests: XCTestCase {
    // MARK: Dependencies
    var sut: SimpleDeviceId!
    var deviceIdStorageMock = DeviceIdStorageMock()
    
    // MARK: Test Lifecycle
    override func setUp() {
        sut = SimpleDeviceId(UIDevice.current, storage: deviceIdStorageMock)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    // MARK: getDeviceId
    func testGetDeviceIdReturnsValue() {
        let deviceId = try? sut.getDeviceId()
        
        XCTAssertTrue(deviceIdStorageMock.retrieveDeviceIdCalled)
        XCTAssertNotNil(deviceId)
    }
    
    // Normally this would work but UIDevice API would have to wrapped and mocked as well
    func testGetDeviceIdThrowsWhenIdNotReady() {
        XCTAssertThrowsError(try sut.getDeviceId()) { error in
            XCTAssertTrue(deviceIdStorageMock.retrieveDeviceIdCalled)
            XCTAssertEqual(error as! SimpleDeviceIdError, .deviceIdNotReady)
        }
    }
    
    func testGetDeviceIdReturnsStoredValue() {
        deviceIdStorageMock.retrieveDeviceIdReturnValue = UUID()
        
        let deviceId = try? sut.getDeviceId()
        
        XCTAssertTrue(deviceIdStorageMock.retrieveDeviceIdCalled)
        XCTAssertFalse(deviceIdStorageMock.storeDeviceIdCalled)
        XCTAssertNotNil(deviceId)
    }
}

// MARK: Mocks
class DeviceIdStorageMock: DeviceIdStorage {
    var storeDeviceIdCalled: Bool = false
    var retrieveDeviceIdCalled: Bool = false
    var retrieveDeviceIdReturnValue: UUID? = nil
    
    func storeDeviceId(_ deviceId: UUID) {
        storeDeviceIdCalled = true
    }
    
    func retrieveDeviceId() -> UUID? {
        retrieveDeviceIdCalled = true
        return retrieveDeviceIdReturnValue
    }
}
