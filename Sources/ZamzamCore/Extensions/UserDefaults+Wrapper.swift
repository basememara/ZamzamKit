//
//  UserDefaults+Wrapper.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-05-24.
//  Taken from: https://github.com/jessesquires/Foil
//
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation.NSUserDefaults

/// A property wrapper that uses `UserDefaults` as a backing store,  whose `wrappedValue` is non-optional and registers a **non-optional default value**.
///
///     final class AppSettings {
///         @Defaults("flagEnabled", defaultValue: true)
///         var flagEnabled: Bool
///
///         @Defaults("totalCount", defaultValue: 0, from: .standard)
///         var totalCount: Int
///
///         @DefaultsOptional("timestamp")
///         var timestamp: Date?
///     }
@propertyWrapper
public struct Defaults<T: UserDefaultsWrapper> {
    private let userDefaults: UserDefaults
    private let defaultValue: T

    /// The key for the value in `UserDefaults`.
    public let key: String

    /// The value retrieved from `UserDefaults`.
    public var wrappedValue: T {
        get { T.object(forKey: key, from: userDefaults) ?? defaultValue }
        set { T.set(newValue, forKey: key, from: userDefaults) }
    }

    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - key: The key for the value in `UserDefaults`.
    ///   - defaultValue: The default value to register for the specified key.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(_ key: String, defaultValue: T, from userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [key: defaultValue.wrappedValue()])
    }

    /// Removes the value of the specified default key.
    public func reset() {
        userDefaults.removeObject(forKey: key)
    }
}

/// A property wrapper that uses `UserDefaults` as a backing store, whose `wrappedValue` is optional and **does not provide default value**.
///
///     final class AppSettings {
///         @Defaults("flagEnabled", defaultValue: true)
///         var flagEnabled: Bool
///
///         @Defaults("totalCount", defaultValue: 0, from: .standard)
///         var totalCount: Int
///
///         @DefaultsOptional("timestamp")
///         var timestamp: Date?
///     }
@propertyWrapper
public struct DefaultsOptional<T: UserDefaultsWrapper> {
    private let userDefaults: UserDefaults

    /// The key for the value in `UserDefaults`.
    public let key: String

    /// The value retreived from `UserDefaults`, if any exists.
    public var wrappedValue: T? {
        get { T.object(forKey: key, from: userDefaults) }
        set {
            guard let newValue = newValue else {
                userDefaults.removeObject(forKey: key)
                return
            }

            T.set(newValue, forKey: key, from: userDefaults)
        }
    }

    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - key: The key for the value in `UserDefaults`.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(_ key: String, from userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }

    /// Removes the value of the specified default key.
    public func reset() {
        userDefaults.removeObject(forKey: key)
    }
}

// MARK: - Types

/// Describes a value that can be stored and fetched from `UserDefaults`.
///
/// Default conformances are provided for: `Bool`, `Int`, `Float`, `Double`, `String`, `URL`,
/// `Date`, `Data`, `Array`, `Set`, `Dictionary`, and `RawRepresentable` types.
public protocol UserDefaultsWrapper {
    /// The type of the value that is stored in `UserDefaults`.
    associatedtype WrappedValue

    /// Initializes the object using the provided value.
    ///
    /// - Parameter wrappedValue: The previously store value fetched from `UserDefaults`.
    init(wrappedValue: WrappedValue)

    /// The value to store in `UserDefaults`.
    func wrappedValue() -> WrappedValue

    /// Returns the object associated with the specified key in the user‘s defaults database.
    /// - Parameters:
    ///   - defaultName: A key in the current user‘s defaults database.
    ///   - userDefaults: The user’s defaults database, where you store key-value pairs persistently across launches of your app.
    static func object(forKey defaultName: String, from userDefaults: UserDefaults) -> Self?

    /// Sets the value of the specified default key in the user‘s defaults database.
    /// - Parameters:
    ///   - value: The object to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    ///   - userDefaults: The user’s defaults database, where you store key-value pairs persistently across launches of your app.
    static func set(_ value: Self, forKey defaultName: String, from userDefaults: UserDefaults)
}

extension UserDefaultsWrapper {
    public init(wrappedValue: Self) {
        self = wrappedValue
    }

    public func wrappedValue() -> Self {
        self
    }

    public static func object(forKey defaultName: String, from userDefaults: UserDefaults) -> Self? {
        guard let object = userDefaults.object(forKey: defaultName) as? WrappedValue else { return nil }
        return Self(wrappedValue: object)
    }

    public static func set(_ value: Self, forKey defaultName: String, from userDefaults: UserDefaults) {
        userDefaults.set(value.wrappedValue(), forKey: defaultName)
    }
}

// MARK: - Conformances

extension Bool: UserDefaultsWrapper {}
extension Int: UserDefaultsWrapper {}
extension Float: UserDefaultsWrapper {}
extension Double: UserDefaultsWrapper {}
extension String: UserDefaultsWrapper {}
extension Date: UserDefaultsWrapper {}
extension Data: UserDefaultsWrapper {}

extension URL: UserDefaultsWrapper {
    public static func object(forKey defaultName: String, from userDefaults: UserDefaults) -> Self? {
        userDefaults.url(forKey: defaultName)
    }

    public static func set(_ value: Self, forKey defaultName: String, from userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: defaultName)
    }
}

extension Array: UserDefaultsWrapper where Element: UserDefaultsWrapper {
    public init(wrappedValue: [Element.WrappedValue]) {
        self = wrappedValue.map { Element(wrappedValue: $0) }
    }

    public func wrappedValue() -> [Element.WrappedValue] {
        map { $0.wrappedValue() }
    }
}

extension Set: UserDefaultsWrapper where Element: UserDefaultsWrapper {
    public init(wrappedValue: [Element.WrappedValue]) {
        self = Set(wrappedValue.map { Element(wrappedValue: $0) })
    }

    public func wrappedValue() -> [Element.WrappedValue] {
        map { $0.wrappedValue() }
    }
}

extension Dictionary: UserDefaultsWrapper where Key == String, Value: UserDefaultsWrapper {
    public init(wrappedValue: [String: Value.WrappedValue]) {
        self = wrappedValue.mapValues { Value(wrappedValue: $0) }
    }

    public func wrappedValue() -> [String: Value.WrappedValue] {
        mapValues { $0.wrappedValue() }
    }
}

extension UserDefaultsWrapper where Self: RawRepresentable {
    public init(wrappedValue: RawValue) {
        // swiftlint:disable:next force_unwrapping
        self = Self(rawValue: wrappedValue)!
    }

    public func wrappedValue() -> RawValue {
        rawValue
    }
}
