//
//  UserDefaultsRepresentableTests.swift
//  ZamzamKitTests
//
//  Created by Basem Emara on 2021-05-24.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
import Combine
@testable import ZamzamCore

// Serialized because `TestSettings` binds its property wrappers to one shared defaults
// suite at declaration, so tests cannot be given a suite of their own.
@Suite(.serialized)
struct UserDefaultsRepresentableTests {
    private let settings = TestSettings()

    init() {
        UserDefaults.testReset()
    }
}

// MARK: - Integration

extension UserDefaultsRepresentableTests {
    @Test
    func integrationBool() {
        let defaultValue = settings.flag
        #expect(defaultValue)
        #expect(UserDefaults.test.bool(forKey: "flag"))

        settings.flag = false
        #expect(!(UserDefaults.test.bool(forKey: "flag")))
    }

    @Test
    func integrationInt() {
        let defaultValue = settings.count
        #expect(defaultValue == 42)
        #expect(UserDefaults.test.integer(forKey: "count") == defaultValue)

        let newValue = 666
        settings.count = newValue
        #expect(UserDefaults.test.integer(forKey: "count") == newValue)
    }

    @Test
    func integrationIntOptional() {
        let defaultValue = settings.countOptional
        #expect(defaultValue == nil)

        let newValue = 5
        settings.countOptional = newValue
        #expect(UserDefaults.test.object(forKey: "countOptional") as? Int == newValue)

        settings.countOptional = nil
        #expect(UserDefaults.test.object(forKey: "countOptional") == nil)
    }

    @Test
    func integrationFloat() {
        let defaultValue = settings.mean
        #expect(defaultValue == 4.2)
        #expect(UserDefaults.test.float(forKey: "mean") == defaultValue)

        let newValue = Float(66.6)
        settings.mean = newValue
        #expect(UserDefaults.test.float(forKey: "mean") == newValue)
    }

    @Test
    func integrationDouble() {
        let defaultValue = settings.average
        #expect(defaultValue == 42.0)
        #expect(UserDefaults.test.double(forKey: "average") == defaultValue)

        let newValue = 6.66
        settings.average = newValue
        #expect(UserDefaults.test.double(forKey: "average") == newValue)
    }

    @Test
    func integrationStringOptional() {
        let defaultValue = settings.username
        #expect(defaultValue == nil)

        let newValue = "@jessesquires"
        settings.username = newValue
        #expect(UserDefaults.test.string(forKey: "username") == newValue)

        settings.username = nil
        #expect(UserDefaults.test.string(forKey: "username") as String? == nil)
    }

    @Test
    func integrationURLOptional() {
        let defaultValue = settings.website
        #expect(defaultValue == nil)

        let newValue = URL(string: "www.jessesquires.com")
        settings.website = newValue
        #expect(UserDefaults.test.url(forKey: "website") == newValue)

        settings.website = nil
        #expect(UserDefaults.test.url(forKey: "website") as URL? == nil)
    }

    @Test
    func integrationDate() {
        let defaultValue = settings.timestamp
        #expect(defaultValue == .distantPast)
        #expect(UserDefaults.test.object(forKey: "timestamp") as? Date == defaultValue)

        let newValue = Date()
        settings.timestamp = newValue
        #expect(UserDefaults.test.object(forKey: "timestamp") as? Date == newValue)
    }

    @Test
    func integrationDataOptional() {
        let defaultValue = settings.data
        #expect(defaultValue == nil)

        let newValue = "text data".data(using: .utf8)
        settings.data = newValue
        #expect(UserDefaults.test.data(forKey: "data") == newValue)

        settings.data = nil
        #expect(UserDefaults.test.data(forKey: "data") == nil)
    }

    @Test
    func integrationArray() {
        let defaultValue = settings.list
        #expect(defaultValue == [])
        #expect(UserDefaults.test.array(forKey: "list") as? [Double] == defaultValue)

        let newValue = [6.66, 7.77, 8.88]
        settings.list = newValue
        #expect(UserDefaults.test.array(forKey: "list") as? [Double] == newValue)
    }

    @Test
    func integrationSet() {
        let defaultValue = settings.set
        #expect(defaultValue == [1, 2, 3])

        let newValue = Set([6, 77, 888])
        settings.set = newValue
        #expect((UserDefaults.test.object(forKey: "set") as? [Int])?.sorted() == [6, 77, 888])
    }

    @Test
    func integrationDictionary() {
        let defaultValue = settings.pairs
        #expect(defaultValue == [:])
        #expect(UserDefaults.test.dictionary(forKey: "pairs") as? [String: Int] == defaultValue)

        let newValue = ["six": 6, "seventy-seven": 77, "eight-hundred eighty eight": 888]
        settings.pairs = newValue
        #expect(UserDefaults.test.dictionary(forKey: "pairs") as? [String: Int] == newValue)
    }

    @Test
    func integrationRawRepresentableString() {
        let defaultValue = settings.fruit
        #expect(defaultValue == .apple)
        #expect(UserDefaults.test.object(forKey: "fruit") as? String == "apple")

        let newValue = TestFruit.orange
        settings.fruit = newValue
        #expect(UserDefaults.test.object(forKey: "fruit") as? String == "orange")
    }

    @Test
    func integrationRawRepresentableInt() {
        let defaultValue = settings.vegetable
        #expect(defaultValue == .carrot)
        #expect(UserDefaults.test.object(forKey: "vegetable") as? Int == 0)

        let newValue = TestVegetable.broccoli
        settings.vegetable = newValue
        #expect(UserDefaults.test.object(forKey: "vegetable") as? Int == 2)
    }

    @Test
    func integrationRawRepresentableCustom() {
        let defaultValue = settings.customRawRepresented
        #expect(defaultValue.rawValue == ["abc": .apple])
        #expect(UserDefaults.test.object(forKey: "customRawRepresented") as? [String: String] == ["abc": "apple"])

        let newValue = TestFruit.orange
        settings.customRawRepresented.rawValue["xyz"] = newValue
        #expect(settings.customRawRepresented.rawValue["xyz"] == newValue)
        #expect(settings.customRawRepresented.rawValue == ["abc": .apple, "xyz": .orange])
        #expect(UserDefaults.test.object(forKey: "customRawRepresented") as? [String: String] == ["abc": "apple", "xyz": "orange"])
    }

    @Test
    func integrationCustomType() {
        let defaultValue = settings.custom
        #expect(defaultValue == nil)

        let newValue = CustomType(abc: "test", xyz: 123)
        settings.custom = newValue
        #expect(settings.custom?.abc == "test")
        #expect(settings.custom?.xyz == 123)
        #expect(UserDefaults.test.object(forKey: "custom") as? String == "test|123")

        settings.custom = nil
        #expect(UserDefaults.test.object(forKey: "custom") == nil)
    }

    @Test(.timeLimit(.minutes(1)))
    func integrationPublisher() async {
        let (values, continuation) = AsyncStream<String?>.makeStream()
        let cancellable = settings
            .publisher(for: \.nickname, options: [.new])
            .sink { continuation.yield($0) }

        defer { cancellable.cancel() }

        settings.nickname = "abc123"

        let publishedValue = await values.first { _ in true }
        #expect(settings.nickname == publishedValue)
    }
}

// MARK: - Wrapped

extension UserDefaultsRepresentableTests {
    @Test
    func wrappedValueBool() {
        let key = "key_\(#function)"
        let defaultValue = true
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Bool.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = false
        model.wrappedValue = newValue
        #expect(Bool.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueInt() {
        let key = "key_\(#function)"
        let defaultValue = 42
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Int.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = 666
        model.wrappedValue = newValue
        #expect(Int.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueFloat() {
        let key = "key_\(#function)"
        let defaultValue = Float(42.0)
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Float.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = Float(66.6)
        model.wrappedValue = newValue
        #expect(Float.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueDouble() {
        let key = "key_\(#function)"
        let defaultValue = Double(42.0)
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Double.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = Double(66.6)
        model.wrappedValue = newValue
        #expect(Double.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueString() {
        let key = "key_\(#function)"
        let defaultValue = "default-value"
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(String.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = "new-value"
        model.wrappedValue = newValue
        #expect(String.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueURL() throws {
        let key = "key_\(#function)"
        let defaultValue = try #require(URL(string: "https://hexedbits.com"))
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(URL.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = URL(string: "https://jessesquires.com")!
        model.wrappedValue = newValue
        #expect(URL.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueDate() {
        let key = "key_\(#function)"
        let defaultValue = Date.distantPast
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Date.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = Date()
        model.wrappedValue = newValue
        #expect(Date.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueData() throws {
        let key = "key_\(#function)"
        let defaultValue = try #require("default-data".data(using: .utf8))
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Data.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = try #require("new-data".data(using: .utf8))
        model.wrappedValue = newValue
        #expect(Data.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueArray() {
        let key = "key_\(#function)"
        let defaultValue = [1, 2, 3]
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Array.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = [4, 5, 6]
        model.wrappedValue = newValue
        #expect(Array.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueSet() {
        let key = "key_\(#function)"
        let defaultValue = Set(["one", "two", "three"])
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Set.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = Set(["four", "five", "size"])
        model.wrappedValue = newValue
        #expect(Set.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueDictionary() {
        let key = "key_\(#function)"
        let defaultValue = ["key1": 42.0,
                            "key2": 4.2]
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Dictionary.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = ["key3": 0.42]
        model.wrappedValue = newValue
        #expect(Dictionary.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueRawRepresentable() {
        let key = "key_\(#function)"
        let defaultValue = TestFruit.apple
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(TestFruit.object(forKey: key, from: .test) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = TestFruit.banana
        model.wrappedValue = newValue
        #expect(TestFruit.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)
    }

    @Test
    func wrappedValueIntOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<Int>(key, from: .test)

        let defaultValue: Int? = Int.object(forKey: key, from: .test)
        #expect(defaultValue == nil)
        #expect(model.wrappedValue == nil)

        let newValue = 666
        model.wrappedValue = newValue
        #expect(Int.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)

        model.wrappedValue = nil
        #expect(model.wrappedValue == nil)

        let fetchedValue: Int? = Int.object(forKey: key, from: .test)
        #expect(fetchedValue == nil)
    }

    @Test
    func wrappedValueStringOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<String>(key, from: .test)

        let defaultValue: String? = String.object(forKey: key, from: .test)
        #expect(defaultValue == nil)
        #expect(model.wrappedValue == nil)

        let newValue = "some text"
        model.wrappedValue = newValue
        #expect(String.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)

        model.wrappedValue = nil
        #expect(model.wrappedValue == nil)

        let fetchedValue: String? = String.object(forKey: key, from: .test)
        #expect(fetchedValue == nil)
    }

    @Test
    func wrappedValueURLOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<URL>(key, from: .test)

        let defaultValue: URL? = URL.object(forKey: key, from: .test)
        #expect(defaultValue == nil)
        #expect(model.wrappedValue == nil)

        let newValue = URL(string: "www.jessesquires.com")
        model.wrappedValue = newValue
        #expect(URL.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)

        model.wrappedValue = nil
        #expect(model.wrappedValue == nil)

        let fetchedValue: URL? = URL.object(forKey: key, from: .test)
        #expect(fetchedValue == nil)
    }

    @Test
    func wrappedValueDateOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<Date>(key, from: .test)

        let defaultValue: Date? = Date.object(forKey: key, from: .test)
        #expect(defaultValue == nil)
        #expect(model.wrappedValue == nil)

        let newValue = Date()
        model.wrappedValue = newValue
        #expect(Date.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)

        model.wrappedValue = nil
        #expect(model.wrappedValue == nil)

        let fetchedValue: Date? = Date.object(forKey: key, from: .test)
        #expect(fetchedValue == nil)
    }

    @Test
    func wrappedValueDictionaryOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<[String: TestFruit]>(key, from: .test)

        let defaultValue: [String: TestFruit]? = Dictionary.object(forKey: key, from: .test)
        #expect(defaultValue == nil)
        #expect(model.wrappedValue == nil)

        let newValue = ["key1": TestFruit.apple, "key2": .orange]
        model.wrappedValue = newValue
        #expect(Dictionary.object(forKey: key, from: .test) == newValue)
        #expect(model.wrappedValue == newValue)

        model.wrappedValue = nil
        #expect(model.wrappedValue == nil)

        let fetchedValue: [String: TestFruit]? = Dictionary.object(forKey: key, from: .test)
        #expect(fetchedValue == nil)
    }
}

// MARK: - Reset

extension UserDefaultsRepresentableTests {
    @Test
    func reset() {
        let key = "key_\(#function)"
        let defaultValue = Double(42.0)
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        #expect(Double.object(forKey: key, from: .test) == defaultValue)
        #expect(UserDefaults.test.double(forKey: key) == defaultValue)
        #expect(model.wrappedValue == defaultValue)

        let newValue = Double(66.6)
        model.wrappedValue = newValue
        #expect(Double.object(forKey: key, from: .test) == newValue)
        #expect(UserDefaults.test.double(forKey: key) == newValue)
        #expect(model.wrappedValue == newValue)

        model.reset()

        #expect(Double.object(forKey: key, from: .test) == defaultValue)
        #expect(UserDefaults.test.double(forKey: key) == defaultValue)
        #expect(model.wrappedValue == defaultValue)
    }

    @Test
    func resetOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<Double>(key, from: .test)

        #expect(Double.object(forKey: key, from: .test) == nil)
        #expect(UserDefaults.test.object(forKey: key) == nil)
        #expect(model.wrappedValue == nil)

        let newValue = Double(66.6)
        model.wrappedValue = newValue
        #expect(Double.object(forKey: key, from: .test) == newValue)
        #expect(UserDefaults.test.double(forKey: key) == newValue)
        #expect(model.wrappedValue == newValue)

        model.reset()

        #expect(Double.object(forKey: key, from: .test) == nil)
        #expect(UserDefaults.test.object(forKey: key) == nil)
        #expect(model.wrappedValue == nil)
    }
}

// MARK: - Helpers

private final class TestSettings: NSObject {
    @Defaults("flag", defaultValue: true, from: .test)
    var flag: Bool

    @Defaults("count", defaultValue: 42, from: .test)
    var count: Int

    @DefaultsOptional("countOptional", from: .test)
    var countOptional: Int?

    @Defaults("mean", defaultValue: 4.2, from: .test)
    var mean: Float

    @Defaults("average", defaultValue: 42.0, from: .test)
    var average: Double

    @DefaultsOptional("username", from: .test)
    var username: String?

    @DefaultsOptional("website", from: .test)
    var website: URL?

    @Defaults("timestamp", defaultValue: .distantPast, from: .test)
    var timestamp: Date

    @DefaultsOptional("data", from: .test)
    var data: Data?

    @Defaults("list", defaultValue: [], from: .test)
    var list: [Double]

    @Defaults("set", defaultValue: [1, 2, 3], from: .test)
    var set: Set<Int>

    @Defaults("pairs", defaultValue: [:], from: .test)
    var pairs: [String: Int]

    @Defaults("fruit", defaultValue: .apple, from: .test)
    var fruit: TestFruit

    @Defaults("vegetable", defaultValue: .carrot, from: .test)
    var vegetable: TestVegetable

    @Defaults("customRawRepresented", defaultValue: TestCustomRepresented(rawValue: ["abc": .apple]), from: .test)
    var customRawRepresented: TestCustomRepresented

    @DefaultsOptional("nickname", from: .test)
    @objc dynamic var nickname: String?

    @DefaultsOptional("custom", from: .test)
    var custom: CustomType?
}

// MARK: - Types

enum TestFruit: String, UserDefaultsRepresentable {
    case apple
    case orange
    case banana
}

enum TestVegetable: Int, UserDefaultsRepresentable {
    case carrot
    case spinach
    case broccoli
}

struct TestCustomRepresented: RawRepresentable, UserDefaultsRepresentable {
    var rawValue: [String: TestFruit]

    init(rawValue: [String: TestFruit]) {
        self.rawValue = rawValue
    }
}

struct CustomType {
    let abc: String
    let xyz: Int
}

extension CustomType: UserDefaultsRepresentable {
    var rawDefaultsValue: String { "\(abc)|\(xyz)" }

    init(rawDefaultsValue: String) {
        let split = rawDefaultsValue.split(separator: "|")
        self.abc = String(split[0])
        self.xyz = Int(split[1]) ?? 0
    }
}

// MARK: - Extensions

private extension UserDefaults {
    static let suiteName = UUID().uuidString
    static let test = UserDefaults(suiteName: suiteName) ?? .standard

    static func testReset() {
        UserDefaults.test.removePersistentDomain(forName: suiteName)
    }
}
