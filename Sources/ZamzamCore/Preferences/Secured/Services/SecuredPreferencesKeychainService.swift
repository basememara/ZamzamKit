//
//  SecuredPreferencesKeychainService.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-07.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

public struct SecuredPreferencesKeychainService: SecuredPreferencesService {
    private static let accessOption: KeychainSwiftAccessOptions = .accessibleAfterFirstUnlock
    private let keychain: KeychainSwift
    
    public init() {
        self.keychain = KeychainSwift() // 3rd Party
        self.keychain.synchronizable = false
    }
    
    public init(teamID: String, accessGroup: String) {
        self.init()
        self.keychain.accessGroup = "\(teamID).\(accessGroup)"
    }
}

public extension SecuredPreferencesKeychainService {
    private static let queue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).SecuredPreferencesKeychainService", qos: .userInitiated)
    
    func get(_ key: SecuredPreferencesAPI.Key, completion: @escaping (String?) -> Void) {
        Self.queue.async {
            let value = self.keychain.get(key.name)
            
            DispatchQueue.main.async {
                completion(value)
            }
        }
    }
}

public extension SecuredPreferencesKeychainService {
    
    func set(_ value: String?, forKey key: SecuredPreferencesAPI.Key) -> Bool {
        guard let value = value else { return remove(key) }
        return keychain.set(value, forKey: key.name)
    }
}

public extension SecuredPreferencesKeychainService {
    
    func remove(_ key: SecuredPreferencesAPI.Key) -> Bool {
        keychain.delete(key.name)
    }
}

// MARK: - External Library

private extension SecuredPreferencesKeychainService {
    
    //
    //  KeychainSwiftDistrib.swift
    //
    //  https://github.com/evgenyneu/keychain-swift
    //  Copied from v19.0.0. Modified for private access controls and lint fixes.
    //

    // swiftlint:disable file_length

    // ----------------------------
    //
    // KeychainSwift.swift
    //
    // ----------------------------

    /**
     
     A collection of helper functions for saving text and data in the keychain.
     
     */
    class KeychainSwift {
        
        var lastQueryParameters: [String: Any]? // Used by the unit tests
        
        /// Contains result code from the last operation. Value is noErr (0) for a successful result.
        var lastResultCode: OSStatus = noErr
        
        var keyPrefix = "" // Can be useful in test.
        
        /**
         
         Specify an access group that will be used to access keychain items. Access groups can be used to share keychain items between applications. When access group value is nil all application access groups are being accessed. Access group name is used by all functions: set, get, delete and clear.
         
         */
        var accessGroup: String?
        
        /**
         
         Specifies whether the items can be synchronized with other devices through iCloud. Setting this property to true will
         add the item to other devices with the `set` method and obtain synchronizable items with the `get` command. Deleting synchronizable items will remove them from all devices. In order for keychain synchronization to work the user must enable "Keychain" in iCloud settings.
         
         Does not work on macOS.
         
         */
        var synchronizable: Bool = false
        
        private let lock = NSLock()
        
        /// Instantiate a KeychainSwift object
        init() { }
        
        /**
         
         - parameter keyPrefix: a prefix that is added before the key in get/set methods. Note that `clear` method still clears everything from the Keychain.
         
         */
        init(keyPrefix: String) {
            self.keyPrefix = keyPrefix
        }
        
        /**
         
         Stores the text value in the keychain item under the given key.
         
         - parameter key: Key under which the text value is stored in the keychain.
         - parameter value: Text string to be written to the keychain.
         - parameter withAccess: Value that indicates when your app needs access to the text in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
         
         - returns: True if the text was successfully written to the keychain.
         
         */
        @discardableResult
        func set(_ value: String, forKey key: String,
                 withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
            
            if let value = value.data(using: String.Encoding.utf8) {
                return set(value, forKey: key, withAccess: access)
            }
            
            return false
        }
        
        /**
         
         Stores the data in the keychain item under the given key.
         
         - parameter key: Key under which the data is stored in the keychain.
         - parameter value: Data to be written to the keychain.
         - parameter withAccess: Value that indicates when your app needs access to the text in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
         
         - returns: True if the text was successfully written to the keychain.
         
         */
        @discardableResult
        func set(_ value: Data, forKey key: String,
                 withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
            
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }
            
            deleteNoLock(key) // Delete any existing key before saving it
            
            let accessible = access?.value ?? KeychainSwiftAccessOptions.defaultOption.value
            
            let prefixedKey = keyWithPrefix(key)
            
            var query: [String: Any] = [
                KeychainSwiftConstants.klass: kSecClassGenericPassword,
                KeychainSwiftConstants.attrAccount: prefixedKey,
                KeychainSwiftConstants.valueData: value,
                KeychainSwiftConstants.accessible: accessible
            ]
            
            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: true)
            lastQueryParameters = query
            
            lastResultCode = SecItemAdd(query as CFDictionary, nil)
            
            return lastResultCode == noErr
        }
        
        /**
         
         Stores the boolean value in the keychain item under the given key.
         
         - parameter key: Key under which the value is stored in the keychain.
         - parameter value: Boolean to be written to the keychain.
         - parameter withAccess: Value that indicates when your app needs access to the value in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
         
         - returns: True if the value was successfully written to the keychain.
         
         */
        @discardableResult
        func set(_ value: Bool, forKey key: String,
                 withAccess access: KeychainSwiftAccessOptions? = nil) -> Bool {
            
            let bytes: [UInt8] = value ? [1] : [0]
            let data = Data(bytes)
            
            return set(data, forKey: key, withAccess: access)
        }
        
        /**
         
         Retrieves the text value from the keychain that corresponds to the given key.
         
         - parameter key: The key that is used to read the keychain item.
         - returns: The text value from the keychain. Returns nil if unable to read the item.
         
         */
        func get(_ key: String) -> String? {
            if let data = getData(key) {
                
                if let currentString = String(data: data, encoding: .utf8) {
                    return currentString
                }
                
                lastResultCode = -67853 // errSecInvalidEncoding
            }
            
            return nil
        }
        
        /**
         
         Retrieves the data from the keychain that corresponds to the given key.
         
         - parameter key: The key that is used to read the keychain item.
         - parameter asReference: If true, returns the data as reference (needed for things like NEVPNProtocol).
         - returns: The text value from the keychain. Returns nil if unable to read the item.
         
         */
        func getData(_ key: String, asReference: Bool = false) -> Data? {
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }
            
            let prefixedKey = keyWithPrefix(key)
            
            var query: [String: Any] = [
                KeychainSwiftConstants.klass: kSecClassGenericPassword,
                KeychainSwiftConstants.attrAccount: prefixedKey,
                KeychainSwiftConstants.matchLimit: kSecMatchLimitOne
            ]
            
            if asReference {
                query[KeychainSwiftConstants.returnReference] = kCFBooleanTrue
            } else {
                query[KeychainSwiftConstants.returnData] =  kCFBooleanTrue
            }
            
            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            lastQueryParameters = query
            
            var result: AnyObject?
            
            lastResultCode = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }
            
            if lastResultCode == noErr {
                return result as? Data
            }
            
            return nil
        }
        
        /**
         
         Retrieves the boolean value from the keychain that corresponds to the given key.
         
         - parameter key: The key that is used to read the keychain item.
         - returns: The boolean value from the keychain. Returns nil if unable to read the item.
         
         */
        func getBool(_ key: String) -> Bool? {
            guard let data = getData(key) else { return nil }
            guard let firstBit = data.first else { return nil }
            return firstBit == 1
        }
        
        /**
         
         Deletes the single keychain item specified by the key.
         
         - parameter key: The key that is used to delete the keychain item.
         - returns: True if the item was successfully deleted.
         
         */
        @discardableResult
        func delete(_ key: String) -> Bool {
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }
            
            return deleteNoLock(key)
        }
        
        /**
         Return all keys from keychain
         
         - returns: An string array with all keys from the keychain.
         
         */
        var allKeys: [String] {
            var query: [String: Any] = [
                KeychainSwiftConstants.klass: kSecClassGenericPassword,
                KeychainSwiftConstants.returnData: true,
                KeychainSwiftConstants.returnAttributes: true,
                KeychainSwiftConstants.returnReference: true,
                KeychainSwiftConstants.matchLimit: KeychainSwiftConstants.secMatchLimitAll
            ]
            
            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            
            var result: AnyObject?
            
            let lastResultCode = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }
            
            if lastResultCode == noErr {
                return (result as? [[String: Any]])?.compactMap {
                    $0[KeychainSwiftConstants.attrAccount] as? String } ?? []
            }
            
            return []
        }
        
        /**
         
         Same as `delete` but is only accessed internally, since it is not thread safe.
         
         - parameter key: The key that is used to delete the keychain item.
         - returns: True if the item was successfully deleted.
         
         */
        @discardableResult
        func deleteNoLock(_ key: String) -> Bool {
            let prefixedKey = keyWithPrefix(key)
            
            var query: [String: Any] = [
                KeychainSwiftConstants.klass: kSecClassGenericPassword,
                KeychainSwiftConstants.attrAccount: prefixedKey
            ]
            
            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            lastQueryParameters = query
            
            lastResultCode = SecItemDelete(query as CFDictionary)
            
            return lastResultCode == noErr
        }
        
        /**
         
         Deletes all Keychain items used by the app. Note that this method deletes all items regardless of the prefix settings used for initializing the class.
         
         - returns: True if the keychain items were successfully deleted.
         
         */
        @discardableResult
        func clear() -> Bool {
            // The lock prevents the code to be run simultaneously
            // from multiple threads which may result in crashing
            lock.lock()
            defer { lock.unlock() }
            
            var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
            query = addAccessGroupWhenPresent(query)
            query = addSynchronizableIfRequired(query, addingItems: false)
            lastQueryParameters = query
            
            lastResultCode = SecItemDelete(query as CFDictionary)
            
            return lastResultCode == noErr
        }
        
        /// Returns the key with currently set prefix.
        func keyWithPrefix(_ key: String) -> String {
            return "\(keyPrefix)\(key)"
        }
        
        func addAccessGroupWhenPresent(_ items: [String: Any]) -> [String: Any] {
            guard let accessGroup = accessGroup else { return items }
            
            var result: [String: Any] = items
            result[KeychainSwiftConstants.accessGroup] = accessGroup
            return result
        }
        
        /**
         
         Adds kSecAttrSynchronizable: kSecAttrSynchronizableAny` item to the dictionary when the `synchronizable` property is true.
         
         - parameter items: The dictionary where the kSecAttrSynchronizable items will be added when requested.
         - parameter addingItems: Use `true` when the dictionary will be used with `SecItemAdd` method (adding a keychain item). For getting and deleting items, use `false`.
         
         - returns: the dictionary with kSecAttrSynchronizable item added if it was requested. Otherwise, it returns the original dictionary.
         
         */
        func addSynchronizableIfRequired(_ items: [String: Any], addingItems: Bool) -> [String: Any] {
            if !synchronizable { return items }
            var result: [String: Any] = items
            result[KeychainSwiftConstants.attrSynchronizable] = addingItems == true ? true : kSecAttrSynchronizableAny
            return result
        }
    }

    // ----------------------------
    //
    // TegKeychainConstants.swift
    //
    // ----------------------------

    /// Constants used by the library
    struct KeychainSwiftConstants {
        /// Specifies a Keychain access group. Used for sharing Keychain items between apps.
        static var accessGroup: String { return toString(kSecAttrAccessGroup) }
        
        /**
         
         A value that indicates when your app needs access to the data in a keychain item. The default value is AccessibleWhenUnlocked. For a list of possible values, see KeychainSwiftAccessOptions.
         
         */
        static var accessible: String { return toString(kSecAttrAccessible) }
        
        /// Used for specifying a String key when setting/getting a Keychain value.
        static var attrAccount: String { return toString(kSecAttrAccount) }
        
        /// Used for specifying synchronization of keychain items between devices.
        static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
        
        /// An item class key used to construct a Keychain search dictionary.
        static var klass: String { return toString(kSecClass) }
        
        /// Specifies the number of values returned from the keychain. The library only supports single values.
        static var matchLimit: String { return toString(kSecMatchLimit) }
        
        /// A return data type used to get the data from the Keychain.
        static var returnData: String { return toString(kSecReturnData) }
        
        /// Used for specifying a value when setting a Keychain value.
        static var valueData: String { return toString(kSecValueData) }
        
        /// Used for returning a reference to the data from the keychain
        static var returnReference: String { return toString(kSecReturnPersistentRef) }
        
        /// A key whose value is a Boolean indicating whether or not to return item attributes
        static var returnAttributes: String { return toString(kSecReturnAttributes) }
        
        /// A value that corresponds to matching an unlimited number of items
        static var secMatchLimitAll: String { return toString(kSecMatchLimitAll) }
        
        static func toString(_ value: CFString) -> String {
            return value as String
        }
    }

    // ----------------------------
    //
    // KeychainSwiftAccessOptions.swift
    //
    // ----------------------------

    /**
     
     These options are used to determine when a keychain item should be readable. The default value is AccessibleWhenUnlocked.
     
     */
    enum KeychainSwiftAccessOptions {
        
        /**
         
         The data in the keychain item can be accessed only while the device is unlocked by the user.
         
         This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
         
         This is the default value for keychain items added without explicitly setting an accessibility constant.
         
         */
        case accessibleWhenUnlocked
        
        /**
         
         The data in the keychain item can be accessed only while the device is unlocked by the user.
         
         This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
         
         */
        case accessibleWhenUnlockedThisDeviceOnly
        
        /**
         
         The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
         
         After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
         
         */
        case accessibleAfterFirstUnlock
        
        /**
         
         The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
         
         After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
         
         */
        case accessibleAfterFirstUnlockThisDeviceOnly
        
        /**
         
         The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
         
         This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
         
         */
        case accessibleWhenPasscodeSetThisDeviceOnly
        
        static var defaultOption: KeychainSwiftAccessOptions {
            return .accessibleWhenUnlocked
        }
        
        var value: String {
            switch self {
            case .accessibleWhenUnlocked:
                return toString(kSecAttrAccessibleWhenUnlocked)
                
            case .accessibleWhenUnlockedThisDeviceOnly:
                return toString(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
                
            case .accessibleAfterFirstUnlock:
                return toString(kSecAttrAccessibleAfterFirstUnlock)
                
            case .accessibleAfterFirstUnlockThisDeviceOnly:
                return toString(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
                
            case .accessibleWhenPasscodeSetThisDeviceOnly:
                return toString(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            }
        }
        
        func toString(_ value: CFString) -> String {
            return KeychainSwiftConstants.toString(value)
        }
    }
}
