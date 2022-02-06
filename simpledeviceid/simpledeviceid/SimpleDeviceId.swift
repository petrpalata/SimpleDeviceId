//
//  SimpleDeviceId.swift
//  SimpleDeviceId
//

import UIKit

public enum SimpleDeviceIdError: Error {
    /// Thrown when the method could not retrieve the UUID from the system API
    case deviceIdNotReady
}

public class SimpleDeviceId {
    private let device: UIDevice
    private let storage: DeviceIdStorage
    
    init(_ device: UIDevice, storage: DeviceIdStorage) {
        self.device = device
        self.storage = storage
    }
    
    /// Public initializer
    public convenience init() {
        self.init(UIDevice.current, storage: KeychainDeviceIdStorage())
    }
    
    /**
     Returns a unique identifier for the current device + vendor pair
     
     - Important: The API makes the best effort to keep the identifier stable even between application reinstalls.
     The core functionality depends on the `identifierForVendor` API that obtains `UUID` for the
     current device + vendor (appId prefix) combination. Since the `identifierForVendor` output
     changes between application reinstalls (to be precise only when there are no other apps from the same vendor
     left on the device), the framework saves the latest value in the Keychain. The Keychain data don't get deleted
     along with the app which enables the framework to improve the identifier stability (i. e. the ID is loaded from
     the Keychain if possible).
     
     - Returns: UUID value representing the device (see discussion for details)
     - Throws: `SimpleDeviceIdError.deviceIdNotReady` in case there is no value stored and
     we failed to retrieve the value from the system API.
    */
    public func getDeviceId() throws -> UUID {
        if let deviceId = storage.retrieveDeviceId() {
            return deviceId
        } else {
            guard let vendorId = device.identifierForVendor else {
                throw SimpleDeviceIdError.deviceIdNotReady
            }
            
            storage.storeDeviceId(vendorId)
            return vendorId
        }
    }
}

