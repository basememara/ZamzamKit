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

/// A property wrapper that uses `UserDefaults` as a backing store,  whose `rawDefaultsValue` is non-optional and registers a **non-optional default value**.
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
///
@propertyWrapper
public struct Defaults<T: UserDefaultsRepresentable> {
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
        userDefaults.register(defaults: [key: defaultValue.rawDefaultsValue])
    }

    /// Removes the value of the specified default key.
    public func reset() {
        userDefaults.removeObject(forKey: key)
    }
}

/// A property wrapper that uses `UserDefaults` as a backing store, whose `rawDefaultsValue` is optional and **does not provide default value**.
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
///     
@propertyWrapper
public struct DefaultsOptional<T: UserDefaultsRepresentable> {
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
/// `Date`, `Data`, `Array`, `Set`, `Dictionary`, `RawRepresentable`, and `TimeZone` types.
public protocol UserDefaultsRepresentable {
    /// The type of the value that is stored in `UserDefaults`.
    associatedtype RawDefaultsValue

    /// The value to store in `UserDefaults`.
    var rawDefaultsValue: RawDefaultsValue { get }

    /// Initializes the object using the provided value.
    ///
    /// - Parameter rawDefaultsValue: The previously store value fetched from `UserDefaults`.
    init(rawDefaultsValue: RawDefaultsValue)

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

extension UserDefaultsRepresentable {
    public var rawDefaultsValue: Self { self }

    public init(rawDefaultsValue: Self) {
        self = rawDefaultsValue
    }

    public static func object(forKey defaultName: String, from userDefaults: UserDefaults) -> Self? {
        guard let object = userDefaults.object(forKey: defaultName) as? RawDefaultsValue else { return nil }
        return Self(rawDefaultsValue: object)
    }

    public static func set(_ value: Self, forKey defaultName: String, from userDefaults: UserDefaults) {
        userDefaults.set(value.rawDefaultsValue, forKey: defaultName)
    }
}

// MARK: - Conformances

extension Bool: UserDefaultsRepresentable {}
extension Int: UserDefaultsRepresentable {}
extension Float: UserDefaultsRepresentable {}
extension Double: UserDefaultsRepresentable {}
extension String: UserDefaultsRepresentable {}
extension Date: UserDefaultsRepresentable {}
extension Data: UserDefaultsRepresentable {}

extension URL: UserDefaultsRepresentable {
    public static func object(forKey defaultName: String, from userDefaults: UserDefaults) -> Self? {
        userDefaults.url(forKey: defaultName)
    }

    public static func set(_ value: Self, forKey defaultName: String, from userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: defaultName)
    }
}

extension Array: UserDefaultsRepresentable where Element: UserDefaultsRepresentable {
    public var rawDefaultsValue: [Element.RawDefaultsValue] {
        map { $0.rawDefaultsValue }
    }

    public init(rawDefaultsValue: [Element.RawDefaultsValue]) {
        self = rawDefaultsValue.map { Element(rawDefaultsValue: $0) }
    }
}

extension Set: UserDefaultsRepresentable where Element: UserDefaultsRepresentable {
    public var rawDefaultsValue: [Element.RawDefaultsValue] {
        map { $0.rawDefaultsValue }
    }

    public init(rawDefaultsValue: [Element.RawDefaultsValue]) {
        self = Set(rawDefaultsValue.map { Element(rawDefaultsValue: $0) })
    }
}

extension Dictionary: UserDefaultsRepresentable where Key == String, Value: UserDefaultsRepresentable {
    public var rawDefaultsValue: [String: Value.RawDefaultsValue] {
        mapValues { $0.rawDefaultsValue }
    }

    public init(rawDefaultsValue: [String: Value.RawDefaultsValue]) {
        self = rawDefaultsValue.mapValues { Value(rawDefaultsValue: $0) }
    }
}

extension UserDefaultsRepresentable where Self: RawRepresentable, Self.RawValue: UserDefaultsRepresentable {
    public var rawDefaultsValue: RawValue.RawDefaultsValue {
        rawValue.rawDefaultsValue
    }

    public init(rawDefaultsValue: RawValue.RawDefaultsValue) {
        // swiftlint:disable:next force_unwrapping
        self = Self(rawValue: Self.RawValue(rawDefaultsValue: rawDefaultsValue))!
    }
}
