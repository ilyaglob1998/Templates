//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import KeychainSwift

final class StorageHelper {
    
    enum StorageError: Error {
        case keychainOnlyStringSupported
    }
    
    enum StorageType {
        case keychain
        case userDefaults
    }
    
    enum StorageKey: String {
        case token
        
        var storageType: StorageType {
            switch self {
            case .token:
                return .keychain
            default:
                return .userDefaults
            }
        }
    }
    
    static func save(_ object: Any?, forKey key: StorageKey) {
        print("Save '\(object)' with key '\(key.rawValue)'")
        switch key.storageType {
        case .keychain:
            try? saveInKeyChain(object, key)
        case .userDefaults:
            saveInUserDefaults(object, key)
        }
    }
    
    static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
        switch key.storageType {
        case .keychain:
            let keychain = KeychainSwift()
            let object = keychain.get(key.rawValue)
            return object as? T
        case .userDefaults:
            let userDefaults = UserDefaults.standard
            let object = userDefaults.object(forKey: key.rawValue)
            return object as? T
        }
    }
    
    // Methods for Saves data
    private static func saveInKeyChain(_ object: Any?, _ key: StorageKey) throws {
        let keychain = KeychainSwift()
        if object == nil {
            keychain.delete(key.rawValue)
        } else {
            guard let objectString = object as? String else { throw StorageError.keychainOnlyStringSupported }
            keychain.set(objectString, forKey: key.rawValue)
        }
    }
    
    private static func saveInUserDefaults(_ object: Any?, _ key: StorageKey) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(object, forKey: key.rawValue)
    }
}


