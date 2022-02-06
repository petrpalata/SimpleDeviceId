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
        guard let deviceIdData = deviceId.uuidString.data(using: .utf8) else {
            return
        }
                
        let queryDictionary: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: storageKey,
            kSecAttrService as String: keychainService,
            kSecValueData as String: deviceIdData
        ]
        
        let addQuery = queryDictionary as CFDictionary
        
        var status = SecItemAdd(addQuery, nil)
        if status == errSecDuplicateItem {
            let updateQuery = [kSecValueData: deviceIdData] as CFDictionary
            status = SecItemUpdate(addQuery, updateQuery)
        } else if status == errSecMissingEntitlement {
            NSLog("Missing keychain entitlement. Failed to save deviceId")
        }
    }
    
    func retrieveDeviceId() -> UUID? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: storageKey,
            kSecAttrService as String: keychainService,
            kSecReturnData as String: true as CFBoolean
        ]
        
        var value: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &value)
        
        guard
            let data = value as? Data,
            let uuidString = String(data: data, encoding: .utf8) else {
                return nil
            }
        return UUID(uuidString: uuidString)
    }
}
