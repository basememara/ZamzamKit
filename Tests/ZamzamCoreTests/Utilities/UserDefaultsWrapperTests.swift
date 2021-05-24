//
//  UserDefaultsWrapperTests.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2021-05-24.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import XCTest
import Combine
@testable import ZamzamCore

final class UserDefaultsWrapperTests: XCTestCase {
    private let settings = TestSettings()
    private var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        try super.setUpWithError()
        UserDefaults.testReset()
    }
}

// MARK: - Integration

extension UserDefaultsWrapperTests {
    func testIntegrationBool() {
        let defaultValue = settings.flag
        XCTAssertTrue(defaultValue)
        XCTAssertTrue(UserDefaults.test.bool(forKey: "flag"))

        settings.flag = false
        XCTAssertFalse(UserDefaults.test.bool(forKey: "flag"))
    }

    func testIntegrationInt() {
        let defaultValue = settings.count
        XCTAssertEqual(defaultValue, 42)
        XCTAssertEqual(UserDefaults.test.integer(forKey: "count"), defaultValue)

        let newValue = 666
        settings.count = newValue
        XCTAssertEqual(UserDefaults.test.integer(forKey: "count"), newValue)
    }

    func testIntegrationIntOptional() {
        let defaultValue = settings.countOptional
        XCTAssertNil(defaultValue)

        let newValue = 5
        settings.countOptional = newValue
        XCTAssertEqual(UserDefaults.test.object(forKey: "countOptional") as? Int, newValue)

        settings.countOptional = nil
        XCTAssertNil(UserDefaults.test.object(forKey: "countOptional"))
    }

    func testIntegrationFloat() {
        let defaultValue = settings.mean
        XCTAssertEqual(defaultValue, 4.2)
        XCTAssertEqual(UserDefaults.test.float(forKey: "mean"), defaultValue)

        let newValue = Float(66.6)
        settings.mean = newValue
        XCTAssertEqual(UserDefaults.test.float(forKey: "mean"), newValue)
    }

    func testIntegrationDouble() {
        let defaultValue = settings.average
        XCTAssertEqual(defaultValue, 42.0)
        XCTAssertEqual(UserDefaults.test.double(forKey: "average"), defaultValue)

        let newValue = 6.66
        settings.average = newValue
        XCTAssertEqual(UserDefaults.test.double(forKey: "average"), newValue)
    }

    func testIntegrationStringOptional() {
        let defaultValue = settings.username
        XCTAssertNil(defaultValue)

        let newValue = "@jessesquires"
        settings.username = newValue
        XCTAssertEqual(UserDefaults.test.string(forKey: "username"), newValue)

        settings.username = nil
        XCTAssertNil(UserDefaults.test.string(forKey: "username") as String?)
    }

    func testIntegrationURLOptional() {
        let defaultValue = settings.website
        XCTAssertNil(defaultValue)

        let newValue = URL(string: "www.jessesquires.com")
        settings.website = newValue
        XCTAssertEqual(UserDefaults.test.url(forKey: "website"), newValue)

        settings.website = nil
        XCTAssertNil(UserDefaults.test.url(forKey: "website") as URL?)
    }

    func testIntegrationDate() {
        let defaultValue = settings.timestamp
        XCTAssertEqual(defaultValue, .distantPast)
        XCTAssertEqual(UserDefaults.test.object(forKey: "timestamp") as? Date, defaultValue)

        let newValue = Date()
        settings.timestamp = newValue
        XCTAssertEqual(UserDefaults.test.object(forKey: "timestamp") as? Date, newValue)
    }

    func testIntegrationDataOptional() {
        let defaultValue = settings.data
        XCTAssertNil(defaultValue)

        let newValue = "text data".data(using: .utf8)
        settings.data = newValue
        XCTAssertEqual(UserDefaults.test.data(forKey: "data"), newValue)

        settings.data = nil
        XCTAssertNil(UserDefaults.test.data(forKey: "data"))
    }

    func testIntegrationArray() {
        let defaultValue = settings.list
        XCTAssertEqual(defaultValue, [])
        XCTAssertEqual(UserDefaults.test.array(forKey: "list") as? [Double], defaultValue)

        let newValue = [6.66, 7.77, 8.88]
        settings.list = newValue
        XCTAssertEqual(UserDefaults.test.array(forKey: "list") as? [Double], newValue)
    }

    func testIntegrationSet() {
        let defaultValue = settings.set
        XCTAssertEqual(defaultValue, [1, 2, 3])

        let newValue = Set([6, 77, 888])
        settings.set = newValue
        XCTAssertEqual(UserDefaults.test.object(forKey: "set") as? Set<Int>.WrappedValue, newValue.wrappedValue())
    }

    func testIntegrationDictionary() {
        let defaultValue = settings.pairs
        XCTAssertEqual(defaultValue, [:])
        XCTAssertEqual(UserDefaults.test.dictionary(forKey: "pairs") as? [String: Int], defaultValue)

        let newValue = ["six": 6, "seventy-seven": 77, "eight-hundred eighty eight": 888]
        settings.pairs = newValue
        XCTAssertEqual(UserDefaults.test.dictionary(forKey: "pairs") as? [String: Int], newValue)
    }

    func testIntegrationRawRepresentable() {
        let defaultValue = settings.fruit
        XCTAssertEqual(defaultValue, .apple)
        XCTAssertEqual(UserDefaults.test.object(forKey: "fruit") as? TestFruit.WrappedValue, TestFruit.apple.rawValue)

        let newValue = TestFruit.orange
        settings.fruit = newValue
        XCTAssertEqual(UserDefaults.test.object(forKey: "fruit") as? TestFruit.WrappedValue, newValue.wrappedValue())
    }

    func testIntegrationCustomType() {
        let defaultValue = settings.custom
        XCTAssertNil(defaultValue)

        let newValue = CustomType(abc: "test", xyz: 123)
        settings.custom = newValue
        XCTAssertEqual(settings.custom?.abc, "test")
        XCTAssertEqual(settings.custom?.xyz, 123)
        XCTAssertEqual(UserDefaults.test.object(forKey: "custom") as? CustomType.WrappedValue, "test|123")

        settings.custom = nil
        XCTAssertNil(UserDefaults.test.object(forKey: "custom"))
    }

    func testIntegrationPublisher() {
        let promise = expectation(description: #function)
        var publishedValue: String?

        settings
            .publisher(for: \.nickname, options: [.new])
            .sink {
                publishedValue = $0
                promise.fulfill()
            }
            .store(in: &cancellable)

        settings.nickname = "abc123"
        wait(for: [promise], timeout: 5)

        XCTAssertEqual(settings.nickname, publishedValue)
    }
}

// MARK: - Wrapped

extension UserDefaultsWrapperTests {
    func testWrappedValueBool() {
        let key = "key_\(#function)"
        let defaultValue = true
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Bool.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = false
        model.wrappedValue = newValue
        XCTAssertEqual(Bool.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueInt() {
        let key = "key_\(#function)"
        let defaultValue = 42
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Int.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = 666
        model.wrappedValue = newValue
        XCTAssertEqual(Int.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueFloat() {
        let key = "key_\(#function)"
        let defaultValue = Float(42.0)
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Float.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = Float(66.6)
        model.wrappedValue = newValue
        XCTAssertEqual(Float.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueDouble() {
        let key = "key_\(#function)"
        let defaultValue = Double(42.0)
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Double.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = Double(66.6)
        model.wrappedValue = newValue
        XCTAssertEqual(Double.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueString() {
        let key = "key_\(#function)"
        let defaultValue = "default-value"
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(String.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = "new-value"
        model.wrappedValue = newValue
        XCTAssertEqual(String.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueURL() throws {
        let key = "key_\(#function)"
        let defaultValue = try XCTUnwrap(URL(string: "https://hexedbits.com"))
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(URL.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = URL(string: "https://jessesquires.com")!
        model.wrappedValue = newValue
        XCTAssertEqual(URL.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueDate() {
        let key = "key_\(#function)"
        let defaultValue = Date.distantPast
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Date.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = Date()
        model.wrappedValue = newValue
        XCTAssertEqual(Date.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueData() throws {
        let key = "key_\(#function)"
        let defaultValue = try XCTUnwrap("default-data".data(using: .utf8))
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Data.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = try XCTUnwrap("new-data".data(using: .utf8))
        model.wrappedValue = newValue
        XCTAssertEqual(Data.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueArray() {
        let key = "key_\(#function)"
        let defaultValue = [1, 2, 3]
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Array.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = [4, 5, 6]
        model.wrappedValue = newValue
        XCTAssertEqual(Array.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueSet() {
        let key = "key_\(#function)"
        let defaultValue = Set(["one", "two", "three"])
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Set.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = Set(["four", "five", "size"])
        model.wrappedValue = newValue
        XCTAssertEqual(Set.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueDictionary() {
        let key = "key_\(#function)"
        let defaultValue = ["key1": 42.0,
                            "key2": 4.2]
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Dictionary.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = ["key3": 0.42]
        model.wrappedValue = newValue
        XCTAssertEqual(Dictionary.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueRawRepresentable() {
        let key = "key_\(#function)"
        let defaultValue = TestFruit.apple
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(TestFruit.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = TestFruit.banana
        model.wrappedValue = newValue
        XCTAssertEqual(TestFruit.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)
    }

    func testWrappedValueIntOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<Int>(key, from: .test)

        let defaultValue: Int? = Int.object(forKey: key, from: .test)
        XCTAssertNil(defaultValue)
        XCTAssertNil(model.wrappedValue)

        let newValue = 666
        model.wrappedValue = newValue
        XCTAssertEqual(Int.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)

        model.wrappedValue = nil
        XCTAssertNil(model.wrappedValue)

        let fetchedValue: Int? = Int.object(forKey: key, from: .test)
        XCTAssertNil(fetchedValue)
    }

    func testWrappedValueStringOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<String>(key, from: .test)

        let defaultValue: String? = String.object(forKey: key, from: .test)
        XCTAssertNil(defaultValue)
        XCTAssertNil(model.wrappedValue)

        let newValue = "some text"
        model.wrappedValue = newValue
        XCTAssertEqual(String.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)

        model.wrappedValue = nil
        XCTAssertNil(model.wrappedValue)

        let fetchedValue: String? = String.object(forKey: key, from: .test)
        XCTAssertNil(fetchedValue)
    }

    func testWrappedValueURLOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<URL>(key, from: .test)

        let defaultValue: URL? = URL.object(forKey: key, from: .test)
        XCTAssertNil(defaultValue)
        XCTAssertNil(model.wrappedValue)

        let newValue = URL(string: "www.jessesquires.com")
        model.wrappedValue = newValue
        XCTAssertEqual(URL.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)

        model.wrappedValue = nil
        XCTAssertNil(model.wrappedValue)

        let fetchedValue: URL? = URL.object(forKey: key, from: .test)
        XCTAssertNil(fetchedValue)
    }

    func testWrappedValueDateOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<Date>(key, from: .test)

        let defaultValue: Date? = Date.object(forKey: key, from: .test)
        XCTAssertNil(defaultValue)
        XCTAssertNil(model.wrappedValue)

        let newValue = Date()
        model.wrappedValue = newValue
        XCTAssertEqual(Date.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)

        model.wrappedValue = nil
        XCTAssertNil(model.wrappedValue)

        let fetchedValue: Date? = Date.object(forKey: key, from: .test)
        XCTAssertNil(fetchedValue)
    }

    func testWrappedValueDictionaryOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<[String: TestFruit]>(key, from: .test)

        let defaultValue: [String: TestFruit]? = Dictionary.object(forKey: key, from: .test)
        XCTAssertNil(defaultValue)
        XCTAssertNil(model.wrappedValue)

        let newValue = ["key1": TestFruit.apple, "key2": .orange]
        model.wrappedValue = newValue
        XCTAssertEqual(Dictionary.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)

        model.wrappedValue = nil
        XCTAssertNil(model.wrappedValue)

        let fetchedValue: [String: TestFruit]? = Dictionary.object(forKey: key, from: .test)
        XCTAssertNil(fetchedValue)
    }
}

// MARK: - Reset

extension UserDefaultsWrapperTests {
    func testReset() {
        let key = "key_\(#function)"
        let defaultValue = Double(42.0)
        var model = Defaults(key, defaultValue: defaultValue, from: .test)

        XCTAssertEqual(Double.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(UserDefaults.test.double(forKey: key), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)

        let newValue = Double(66.6)
        model.wrappedValue = newValue
        XCTAssertEqual(Double.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(UserDefaults.test.double(forKey: key), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)

        model.reset()

        XCTAssertEqual(Double.object(forKey: key, from: .test), defaultValue)
        XCTAssertEqual(UserDefaults.test.double(forKey: key), defaultValue)
        XCTAssertEqual(model.wrappedValue, defaultValue)
    }

    func testResetOptional() {
        let key = "key_\(#function)"
        var model = DefaultsOptional<Double>(key, from: .test)

        XCTAssertNil(Double.object(forKey: key, from: .test))
        XCTAssertNil(UserDefaults.test.object(forKey: key))
        XCTAssertNil(model.wrappedValue)

        let newValue = Double(66.6)
        model.wrappedValue = newValue
        XCTAssertEqual(Double.object(forKey: key, from: .test), newValue)
        XCTAssertEqual(UserDefaults.test.double(forKey: key), newValue)
        XCTAssertEqual(model.wrappedValue, newValue)

        model.reset()

        XCTAssertNil(Double.object(forKey: key, from: .test))
        XCTAssertNil(UserDefaults.test.object(forKey: key))
        XCTAssertNil(model.wrappedValue)
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

    @DefaultsOptional("nickname", from: .test)
    @objc dynamic var nickname: String?

    @DefaultsOptional("custom", from: .test)
    var custom: CustomType?
}

// MARK: - Types

enum TestFruit: String, UserDefaultsWrapper {
    case apple
    case orange
    case banana
}

struct CustomType {
    let abc: String
    let xyz: Int
}

extension CustomType: UserDefaultsWrapper {
    init(wrappedValue: String) {
        let split = wrappedValue.split(separator: "|")
        self.abc = String(split[0])
        self.xyz = Int(split[1]) ?? 0
    }

    func wrappedValue() -> String {
        "\(abc)|\(xyz)"
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
