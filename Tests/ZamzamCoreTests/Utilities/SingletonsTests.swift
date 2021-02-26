//
//  SingletonsTests.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2021-02-06.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class SingletonsTests: XCTestCase {}

extension SingletonsTests {

    func testSingleContext() {
        // Given
        let context = MyContext()

        // When
        let networkService1ID = context.networkService().id
        let networkService2ID = context.networkService().id

        let locationService1ID = context.locationService().id
        let locationService2ID = context.locationService().id

        let nonSingleService1ID = context.nonSingleService().id
        let nonSingleService2ID = context.nonSingleService().id

        // Then
        XCTAssertEqual(networkService1ID, networkService2ID)
        XCTAssertEqual(locationService1ID, locationService2ID)
        XCTAssertNotEqual(nonSingleService1ID, nonSingleService2ID)
    }
}

extension SingletonsTests {

    func testMultipleContexts() {
        // Given
        let context1 = MyContext()
        let context2 = AnotherContext()

        // When
        let networkService1ID = context1.networkService().id
        let networkService2ID = context2.networkService().id

        let locationService1ID = context1.locationService().id
        let locationService2ID = context2.locationService().id

        let nonSingleService1ID = context1.nonSingleService().id
        let nonSingleService2ID = context2.nonSingleService().id

        // Then
        XCTAssertNotEqual(networkService1ID, networkService2ID)
        XCTAssertNotEqual(locationService1ID, locationService2ID)
        XCTAssertNotEqual(nonSingleService1ID, nonSingleService2ID)
    }
}

extension SingletonsTests {

    func testReset() {
        // Given
        let context = MyContext()

        let networkService1ID = context.networkService().id
        let locationService1ID = context.locationService().id

        // When
        context.reset()

        let networkService2ID = context.networkService().id
        let locationService2ID = context.locationService().id

        // Then
        XCTAssertNotEqual(networkService1ID, networkService2ID)
        XCTAssertNotEqual(locationService1ID, locationService2ID)
    }
}

// MARK: - Types

private extension SingletonsTests {

    struct MyContext: SomeContext {

        func networkService() -> NetworkService {
            single {
                NetworkMockService()
            }
        }

        func nonSingleService() -> NonSingleService {
            NonSingleDefaultService()
        }
    }

    struct AnotherContext: SomeContext {

        func nonSingleService() -> NonSingleService {
            NonSingleDefaultService()
        }
    }
}

private extension SingletonsTests {

    struct NetworkDefaultService: NetworkService {
        let id = UUID().uuidString
    }

    struct NetworkMockService: NetworkService {
        let id = UUID().uuidString
    }

    class LocationDefaultService: LocationService {
        let id = UUID().uuidString
    }

    struct NonSingleDefaultService: NonSingleService {
        let id = UUID().uuidString
    }
}

private protocol SomeContext: Singletons {
    func networkService() -> NetworkService
    func locationService() -> LocationService
    func nonSingleService() -> NonSingleService
}

private extension SomeContext {

    func networkService() -> NetworkService {
        single {
            SingletonsTests.NetworkDefaultService()
        }
    }

    func locationService() -> LocationService {
        single {
            SingletonsTests.LocationDefaultService()
        }
    }
}

private protocol NetworkService {
    var id: String { get }
}

private protocol LocationService {
    var id: String { get }
}

private protocol NonSingleService {
    var id: String { get }
}
