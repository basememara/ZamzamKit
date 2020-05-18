//
//  ViewControllerLifecycleObserversTests.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2019-05-26.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import XCTest
import ZamzamUI

class ViewControllerLifecycleObserversTests: XCTestCase {}

// MARK: - ViewDidLoad

extension ViewControllerLifecycleObserversTests {
    
    func testViewDidLoadObserverIsAddedAsChild() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidLoad { _ in }
        
        // Then
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testViewDidLoadObserverViewIsAddedAsSubview() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidLoad { _ in }
        
        // Then
        XCTAssertEqual(sut.children.first?.view.superview, sut.view)
    }
    
    func testViewDidLoadObserverViewIsInvisible() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidLoad { _ in }
        
        // Then
        XCTAssert(sut.children.first?.view?.isHidden == true)
    }
    
    func testViewDidLoadObserverFiresOnLoad() {
        // Given
        let sut = UIViewController()
        var callCount = 0
        
        // When
        sut.viewDidLoad { _ in
            callCount += 1
        }
        
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertEqual(callCount, 1)
    }
    
    func testCanRemoveViewDidLoadObserver() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidLoad { _ in }.remove()
        
        // Then
        XCTAssert(sut.children.isEmpty)
    }
    
    func testCanRemoveViewDidLoadObserverView() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidLoad { _ in }.remove()
        
        // Then
        XCTAssert(sut.view.subviews.isEmpty)
    }
}
    
// MARK: - ViewWillAppear

extension ViewControllerLifecycleObserversTests {
    
    func testViewWillAppearObserverIsAddedAsChild() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillAppear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testViewWillAppearObserverViewIsAddedAsSubview() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillAppear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.first?.view.superview, sut.view)
    }
    
    func testViewWillAppearObserverViewIsInvisible() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillAppear { _ in }
        
        // Then
        XCTAssert(sut.children.first?.view?.isHidden == true)
    }
    
    func testViewWillAppearObserverDoesNotFireOnLoad() {
        // Given
        let sut = UIViewController()
        var callCount = 0
        
        // When
        sut.viewWillAppear { _ in
            callCount += 1
        }
        
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertEqual(callCount, 0)
    }
    
    func testCanRemoveViewWillAppearObserver() {
        let sut = UIViewController()
        
        // When
        sut.viewWillAppear { _ in }.remove()
        
        // Then
        XCTAssert(sut.children.isEmpty)
    }
    
    func testCanRemoveViewWillAppearObserverView() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillAppear { _ in }.remove()
        
        // Then
        XCTAssert(sut.view.subviews.isEmpty)
    }
}

// MARK: - ViewDidAppear

extension ViewControllerLifecycleObserversTests {
    
    func testViewDidAppearObserverIsAddedAsChild() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidAppear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testViewDidAppearObserverViewIsAddedAsSubview() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidAppear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.first?.view.superview, sut.view)
    }
    
    func testViewDidAppearObserverViewIsInvisible() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidAppear { _ in }
        
        // Then
        XCTAssert(sut.children.first?.view?.isHidden == true)
    }
    
    func testViewDidAppearObserverDoesNotFireOnLoad() {
        // Given
        let sut = UIViewController()
        var callCount = 0
        
        // When
        sut.viewDidAppear { _ in
            callCount += 1
        }
        
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertEqual(callCount, 0)
    }
    
    func testCanRemoveViewDidAppearObserver() {
        let sut = UIViewController()
        
        // When
        sut.viewDidAppear { _ in }.remove()
        
        // Then
        XCTAssert(sut.children.isEmpty)
    }
    
    func testCanRemoveViewDidAppearObserverView() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidAppear { _ in }.remove()
        
        // Then
        XCTAssert(sut.view.subviews.isEmpty)
    }
}

// MARK: - ViewWillDisappear

extension ViewControllerLifecycleObserversTests {
    
    func testViewWillDisappearObserverIsAddedAsChild() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillDisappear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testViewWillDisappearObserverViewIsAddedAsSubview() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillDisappear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.first?.view.superview, sut.view)
    }
    
    func testViewWillDisappearObserverViewIsInvisible() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillDisappear { _ in }
        
        // Then
        XCTAssert(sut.children.first?.view?.isHidden == true)
    }
    
    func testViewWillDisappearObserverDoesNotFireOnLoad() {
        // Given
        let sut = UIViewController()
        var callCount = 0
        
        // When
        sut.viewWillDisappear { _ in
            callCount += 1
        }
        
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertEqual(callCount, 0)
    }
    
    func testCanRemoveViewWillDisappearObserver() {
        let sut = UIViewController()
        
        // When
        sut.viewWillDisappear { _ in }.remove()
        
        // Then
        XCTAssert(sut.children.isEmpty)
    }
    
    func testCanRemoveViewWillDisappearObserverView() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewWillDisappear { _ in }.remove()
        
        // Then
        XCTAssert(sut.view.subviews.isEmpty)
    }
}

// MARK: - ViewDidDisappear

extension ViewControllerLifecycleObserversTests {
    
    func testViewDidDisappearObserverIsAddedAsChild() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidDisappear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.count, 1)
    }
    
    func testViewDidDisappearObserverViewIsAddedAsSubview() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidDisappear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.first?.view.superview, sut.view)
    }
    
    func testViewDidDisappearObserverViewIsInvisible() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidDisappear { _ in }
        
        // Then
        XCTAssert(sut.children.first?.view?.isHidden == true)
    }
    
    func testViewDidDisappearObserverDoesNotFireOnLoad() {
        // Given
        let sut = UIViewController()
        var callCount = 0
        
        // When
        sut.viewDidDisappear { _ in
            callCount += 1
        }
        
        // Then
        XCTAssertNotNil(sut.view)
        XCTAssertEqual(callCount, 0)
    }
    
    func testCanRemoveViewDidDisappearObserver() {
        let sut = UIViewController()
        
        // When
        sut.viewDidDisappear { _ in }.remove()
        
        // Then
        XCTAssert(sut.children.isEmpty)
    }
    
    func testCanRemoveViewDidDisappearObserverView() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidDisappear { _ in }.remove()
        
        // Then
        XCTAssert(sut.view.subviews.isEmpty)
    }
}

// MARK: - Callback Parameter Tests

extension ViewControllerLifecycleObserversTests {
    
    func testObserverReturningInstance() {
        // Given
        let promise = expectation(description: #function)
        let window = UIWindow(frame: UIScreen.main.bounds)
        let sut = UIViewController()
        
        promise.expectedFulfillmentCount = 5
        
        sut.viewDidLoad { [weak sut] in
            // Then
            XCTAssertEqual(sut, $0)
            promise.fulfill()
        }
        
        sut.viewWillAppear { [weak sut] in
            // Then
            XCTAssertEqual(sut, $0)
            promise.fulfill()
        }
        
        sut.viewDidAppear { [weak sut] in
            // Then
            XCTAssertEqual(sut, $0)
            promise.fulfill()
        }
        
        sut.viewWillDisappear { [weak sut] in
            // Then
            XCTAssertEqual(sut, $0)
            promise.fulfill()
        }
        
        sut.viewDidDisappear { [weak sut] in
            // Then
            XCTAssertEqual(sut, $0)
            promise.fulfill()
        }
        
        // When
        window.rootViewController = sut
        window.makeKeyAndVisible()
        window.rootViewController = nil
        
        wait(for: [promise], timeout: 1)
    }
}

// MARK: - Integration Tests

extension ViewControllerLifecycleObserversTests {
    
    func testObserversWorkingWithNavigationControllerAnimatedTransitions() {
        // Given
        let promise = expectation(description: #function)
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController()
        let sut = UIViewController()
        
        sut.viewDidLoad { [weak sut, weak window] _ in
            sut?.viewWillAppear {
                sut?.viewDidAppear { _ in
                    sut?.viewWillDisappear { _ in
                        sut?.viewDidDisappear { _ in
                            promise.fulfill()
                        }
                    }
                    
                    window?.rootViewController = nil
                }
            }
        }
        
        // When
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        navigation.pushViewController(sut, animated: true)
        
        // Then
        wait(for: [promise], timeout: 5)
    }
    
    func testMultipleObserversAdded() {
        // Given
        let sut = UIViewController()
        
        // When
        sut.viewDidLoad { _ in }
        sut.viewDidLoad { _ in }
        sut.viewDidLoad { _ in }
        sut.viewWillAppear { _ in }
        sut.viewWillAppear { _ in }
        sut.viewWillAppear { _ in }
        sut.viewDidAppear { _ in }
        sut.viewDidAppear { _ in }
        sut.viewDidAppear { _ in }
        sut.viewWillDisappear { _ in }
        sut.viewWillDisappear { _ in }
        sut.viewWillDisappear { _ in }
        sut.viewDidDisappear { _ in }
        sut.viewDidDisappear { _ in }
        sut.viewDidDisappear { _ in }
        
        // Then
        XCTAssertEqual(sut.children.count, 15)
    }
}
#endif
