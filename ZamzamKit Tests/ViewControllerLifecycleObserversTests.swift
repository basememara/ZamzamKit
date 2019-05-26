//
//  ViewControllerLifecycleObserversTests.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-05-26.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamKit

// TODO: Move to hosted unit test
class ViewControllerLifecycleObserversTests: XCTestCase {
    
    // MARK: View Will Appear Tests
    
    func testViewWillAppearObserverIsAddedAsChild() {
        assertObserverIsAddedAsChild(when: { sut in
            sut.viewWillAppear { _ in }
        })
    }
    
    func testViewWillAppearObserverViewIsAddedAsSubview() {
        assertObserverViewIsAddedAsSubview(when: { sut in
            sut.viewWillAppear { _ in }
        })
    }
    
    func testViewWillAppearObserverViewIsInvisible() {
        assertObserverViewIsInvisible(when: { sut in
            sut.viewWillAppear { _ in }
        })
    }
    
    func testViewWillAppearObserverFiresCallback() {
        assertObserver(
            firesCallback: { $0.viewWillAppear },
            when: { $0.viewWillAppear(false) })
    }
    
    func testCanRemoveViewWillAppearObserver() {
        assertCanRemoveObserver(when: { sut in
            sut.viewWillAppear { _ in }
        })
    }
    
    func testCanRemoveViewWillAppearObserverView() {
        assertCanRemoveObserverView(when: { sut in
            sut.viewWillAppear { _ in }
        })
    }
    
    // MARK: View Did Appear Tests
    
    func testViewDidAppearObserverIsAddedAsChild() {
        assertObserverIsAddedAsChild(when: { sut in
            sut.viewDidAppear { _ in }
        })
    }
    
    func testViewDidAppearObserverViewIsAddedAsSubview() {
        assertObserverViewIsAddedAsSubview(when: { sut in
            sut.viewDidAppear { _ in }
        })
    }
    
    func testViewDidAppearObserverViewIsInvisible() {
        assertObserverViewIsInvisible(when: { sut in
            sut.viewDidAppear { _ in }
        })
    }
    
    func testViewDidAppearObserverFiresCallback() {
        assertObserver(
            firesCallback: { $0.viewDidAppear },
            when: { $0.viewDidAppear(false) })
    }
    
    func testCanRemoveViewDidAppearObserver() {
        assertCanRemoveObserver(when: { sut in
            sut.viewDidAppear { _ in }
        })
    }
    
    func testCanRemoveViewDidAppearObserverView() {
        assertCanRemoveObserverView(when: { sut in
            sut.viewDidAppear { _ in }
        })
    }
    
    // MARK: View Will Disappear Tests
    
    func testViewWillDisappearObserverIsAddedAsChild() {
        assertObserverIsAddedAsChild(when: { sut in
            sut.viewWillDisappear { _ in }
        })
    }
    
    func testViewWillDisappearObserverViewIsAddedAsSubview() {
        assertObserverViewIsAddedAsSubview(when: { sut in
            sut.viewWillDisappear { _ in }
        })
    }
    
    func testViewWillDisappearObserverViewIsInvisible() {
        assertObserverViewIsInvisible(when: { sut in
            sut.viewWillDisappear { _ in }
        })
    }
    
    func testViewWillDisappearObserverFiresCallback() {
        assertObserver(
            firesCallback: { $0.viewWillDisappear },
            when: { $0.viewWillDisappear(false) })
    }
    
    func testCanRemoveViewWillDisappearObserver() {
        assertCanRemoveObserver(when: { sut in
            sut.viewWillDisappear { _ in }
        })
    }
    
    func testCanRemoveViewWillDisappearObserverView() {
        assertCanRemoveObserverView(when: { sut in
            sut.viewWillDisappear { _ in }
        })
    }
    
    // MARK: View Did Disappear Tests
    
    func testViewDidDisappearObserverIsAddedAsChild() {
        assertObserverIsAddedAsChild(when: { sut in
            sut.viewDidDisappear { _ in }
        })
    }
    
    func testViewDidDisappearObserverViewIsAddedAsSubview() {
        assertObserverViewIsAddedAsSubview(when: { sut in
            sut.viewDidDisappear { _ in }
        })
    }
    
    func testViewDidDisappearObserverViewIsInvisible() {
        assertObserverViewIsInvisible(when: { sut in
            sut.viewDidDisappear { _ in }
        })
    }
    
    func testViewDidDisappearObserverFiresCallback() {
        assertObserver(
            firesCallback: { $0.viewDidDisappear },
            when: { $0.viewDidDisappear(false) })
    }
    
    func testCanRemoveViewDidDisappearObserver() {
        assertCanRemoveObserver(when: { sut in
            sut.viewDidDisappear { _ in }
        })
    }
    
    func testCanRemoveViewDidDisappearObserverView() {
        assertCanRemoveObserverView(when: { sut in
            sut.viewDidDisappear { _ in }
        })
    }
    
    // MARK: Integration Tests
    
    func testObserversWorkingWithNavigationControllerAnimatedTransitions() {
        let navigation = UINavigationController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        
        let exp = expectation(description: "Wait for lifecycle callbacks")
        let view = UIViewController()
        
        view.viewWillAppear { [weak view, weak navigation] _ in
            view?.viewDidAppear { _ in
                view?.viewWillDisappear { _ in
                    view?.viewDidDisappear { _ in
                        exp.fulfill()
                    }
                }
                
                navigation?.setViewControllers([], animated: true)
            }
        }
        
        navigation.pushViewController(view, animated: true)
        wait(for: [exp], timeout: 1)
    }
    
    func testObserversWorkingWithNavigationControllerNonAnimatedTransitions() {
        let navigation = UINavigationController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        
        let exp = expectation(description: "Wait for lifecycle callbacks")
        let view = UIViewController()
        
        view.viewWillAppear { [weak view, weak navigation] _ in
            view?.viewDidAppear { _ in
                view?.viewWillDisappear { _ in
                    view?.viewDidDisappear { _ in
                        exp.fulfill()
                    }
                }
                
                navigation?.setViewControllers([], animated: false)
            }
        }
        
        navigation.pushViewController(view, animated: false)
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: Helpers
    
    func assertObserverIsAddedAsChild(when action: @escaping (UIViewController) -> Void, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        
        action(sut)
        
        XCTAssertEqual(sut.children.count, 1, file: file, line: line)
    }
    
    func assertObserverViewIsAddedAsSubview(when action: @escaping (UIViewController) -> Void, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        
        action(sut)
        
        let observer = sut.children.first
        XCTAssertEqual(observer?.view.superview, sut.view, file: file, line: line)
    }
    
    func assertObserverViewIsInvisible(when action: @escaping (UIViewController) -> Void, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        
        action(sut)
        
        let observer = sut.children.first
        XCTAssertEqual(observer?.view?.isHidden, true, file: file, line: line)
    }
    
    func assertObserver(
        firesCallback callback: (UIViewController) -> ((@escaping (UIViewController?) -> Void) -> ViewControllerLifecycleObserver),
        when action: @escaping (UIViewController) -> Void,
        file: StaticString = #file,
        line: UInt = #line
        ) {
        let sut = UIViewController()
        
        var callCount = 0
        _ = callback(sut)({ _ in callCount += 1 })
        
        let observer = sut.children.first!
        XCTAssertEqual(callCount, 0, file: file, line: line)
        
        action(observer)
        XCTAssertEqual(callCount, 1, file: file, line: line)
        
        action(observer)
        XCTAssertEqual(callCount, 2, file: file, line: line)
    }
    
    func assertCanRemoveObserver(when action: @escaping (UIViewController) -> ViewControllerLifecycleObserver, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        
        action(sut).remove()
        
        XCTAssertEqual(sut.children.count, 0, file: file, line: line)
    }
    
    func assertCanRemoveObserverView(when action: @escaping (UIViewController) -> ViewControllerLifecycleObserver, file: StaticString = #file, line: UInt = #line) {
        let sut = UIViewController()
        
        action(sut).remove()
        
        XCTAssertEqual(sut.view.subviews.count, 0, file: file, line: line)
    }
}
