//
//  SimpleDeviceId.swift
//  SimpleDeviceId
//

import UIKit

public class SimpleDeviceId {
    private let device = UIDevice.current
    
    /// Retrieves device identifier. See discussion for caveats
    public func getDeviceId() -> UUID? {
        let vendorId = device.identifierForVendor
        return vendorId
    }
}
