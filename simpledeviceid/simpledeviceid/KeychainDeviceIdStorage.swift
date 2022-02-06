//
//  KeychainDeviceIdStorage.swift
//  SimpleDeviceId
//

import Security

protocol DeviceIdStorage {
    func storeDeviceId(_ deviceId: UUID)
    func retrieveDeviceId() -> UUID?
}

class KeychainDeviceIdStorage: DeviceIdStorage {
    private let keychainService = "com.petrpalata.simpledeviceid.keychain"
    private let storageKey = "deviceId"
    
    func storeDeviceId(_ deviceId: UUID) {
        let queryDictionary: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: storageKey,
            kSecAttrService as String: keychainService,
            kSecValueData as String: deviceId.uuidString,
        ]
        
        let addQuery = queryDictionary as CFDictionary
        
        let status = SecItemAdd(addQuery, nil)
        if status == errSecDuplicateItem {
            let updateQuery = [kSecValueData: deviceId] as CFDictionary
            SecItemUpdate(addQuery, updateQuery)
        } else if status == errSecMissingEntitlement {
            NSLog("Missing keychain entitlement. Failed to save deviceId")
        }
    }
    
    func retrieveDeviceId() -> UUID? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: storageKey,
            kSecAttrService as String: keychainService,
        ]
        
        var value: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &value)
        guard let uuidString = value as? String else {
            return nil
        }
        return UUID(uuidString: uuidString)
    }
}
