//
//  PreferencesPublisherTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-08-03.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(Combine)
import XCTest
import ZamzamCore
import Combine

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
final class PreferencesPublisherTests: XCTestCase {
    
    private lazy var preferences = Preferences(
        service: PreferencesDefaultsService(
            defaults: UserDefaults(suiteName: "PreferencesPublisherTests")!
        )
    )
    
    private var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        preferences.remove(.testPublisher)
    }
    
    override func tearDown() {
        super.tearDown()
        cancellable.removeAll()
    }
}

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension PreferencesPublisherTests {
    
    func testPublisher() {
        // Given
        let promise = expectation(description: #function)
        var publisherWasFired = false
        
        // When
        preferences.publisher
            .sink { key in
                guard key == PreferencesAPI.Keys.testPublisher.name else { return }
                publisherWasFired = true
                promise.fulfill()
            }
            .store(in: &cancellable)
        
        preferences.set("abc", forKey: .testPublisher)
        
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssert(publisherWasFired)
        XCTAssertEqual(preferences.get(.testPublisher), "abc")
    }
}
#endif

private extension PreferencesAPI.Keys {
    static let testPublisher = PreferencesAPI.Key<String?>("testPublisher")
}
