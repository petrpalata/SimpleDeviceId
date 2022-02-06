//
//  SimpleDeviceId.swift
//  SimpleDeviceId
//

import UIKit

public class SimpleDeviceId {
    private let device = UIDevice.current
    private let keychain = KeychainDeviceIdStorage()
    
    public init() {}
    
    /// Retrieves device identifier. See discussion for caveats
    public func getDeviceId() -> UUID? {
        if let deviceId = keychain.retrieveDeviceId() {
            return deviceId
        } else {
            guard let vendorId = device.identifierForVendor else {
                return nil
            }
            keychain.storeDeviceId(vendorId)
            return vendorId
        }
    }
}

