//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-09-27.
//

import XCTest
import ZamzamCore

final class DependencyTests: XCTestCase {
    
    private static let dependencies = Dependencies {
        Module { WidgetModule() as WidgetModuleType }
        Module { SampleModule() as SampleModuleType }
        Module("abc") { SampleModule(value: "123") as SampleModuleType }
    }
    
    @Inject private var widgetModule: WidgetModuleType
    @Inject private var sampleModule: SampleModuleType
    @Inject("abc") private var sampleModule2: SampleModuleType
    
    private lazy var widgetWorker: WidgetWorkerType = widgetModule.component()
    private lazy var someObject: SomeObjectType = sampleModule.component()
    private lazy var anotherObject: AnotherObjectType = sampleModule.component()
    private lazy var viewModelObject: ViewModelObjectType = sampleModule.component()
    private lazy var viewControllerObject: ViewControllerObjectType = sampleModule.component()
    
    override class func setUp() {
        super.setUp()
        dependencies.build()
    }
}

// MARK: - Test Cases

extension DependencyTests {
    
    func testResolver() {
        // Given
        let widgetModuleResult = widgetModule.test()
        let sampleModuleResult = sampleModule.test()
        let sampleModule2Result = sampleModule2.test()
        let widgetResult = widgetWorker.fetch(id: 3)
        let someResult = someObject.testAbc()
        let anotherResult = anotherObject.testXyz()
        let viewModelResult = viewModelObject.testLmn()
        let viewModelNestedResult = viewModelObject.testLmnNested()
        let viewControllerResult = viewControllerObject.testRst()
        let viewControllerNestedResult = viewControllerObject.testRstNested()
        
        // Then
        XCTAssertEqual(widgetModuleResult, "WidgetModule.test()")
        XCTAssertEqual(sampleModuleResult, "SampleModule.test()")
        XCTAssertEqual(sampleModule2Result, "SampleModule.test()123")
        XCTAssertEqual(widgetResult, "|MediaRealmStore.3||MediaNetworkRemote.3|")
        XCTAssertEqual(someResult, "SomeObject.testAbc")
        XCTAssertEqual(anotherResult, "AnotherObject.testXyz|SomeObject.testAbc")
        XCTAssertEqual(viewModelResult, "SomeViewModel.testLmn|SomeObject.testAbc")
        XCTAssertEqual(viewModelNestedResult, "SomeViewModel.testLmnNested|AnotherObject.testXyz|SomeObject.testAbc")
        XCTAssertEqual(viewControllerResult, "SomeViewController.testRst|SomeObject.testAbc")
        XCTAssertEqual(viewControllerNestedResult, "SomeViewController.testRstNested|AnotherObject.testXyz|SomeObject.testAbc")
    }
}

// MARK: - Subtypes

extension DependencyTests {

    struct WidgetModule: WidgetModuleType {
        
        func component() -> WidgetWorkerType {
            WidgetWorker(
                store: component(),
                remote: component()
            )
        }
        
        func component() -> WidgetRemote {
            WidgetNetworkRemote(httpService: component())
        }
        
        func component() -> WidgetStore {
            WidgetRealmStore()
        }
        
        func component() -> HTTPServiceType {
            HTTPService()
        }
        
        func test() -> String {
            "WidgetModule.test()"
        }
    }

    struct SampleModule: SampleModuleType {
        let value: String?
        
        init(value: String? = nil) {
            self.value = value
        }
        
        func component() -> SomeObjectType {
            SomeObject()
        }
        
        func component() -> AnotherObjectType {
            AnotherObject(someObject: component())
        }
        
        func component() -> ViewModelObjectType {
            SomeViewModel(
                someObject: component(),
                anotherObject: component()
            )
        }
        
        func component() -> ViewControllerObjectType {
            SomeViewController()
        }
        
        func test() -> String {
            "SampleModule.test()\(value ?? "")"
        }
    }

    struct SomeObject: SomeObjectType {
        func testAbc() -> String {
            "SomeObject.testAbc"
        }
    }

    struct AnotherObject: AnotherObjectType {
        private let someObject: SomeObjectType
        
        init(someObject: SomeObjectType) {
            self.someObject = someObject
        }
        
        func testXyz() -> String {
            "AnotherObject.testXyz|" + someObject.testAbc()
        }
    }

    struct SomeViewModel: ViewModelObjectType {
        private let someObject: SomeObjectType
        private let anotherObject: AnotherObjectType
        
        init(someObject: SomeObjectType, anotherObject: AnotherObjectType) {
            self.someObject = someObject
            self.anotherObject = anotherObject
        }
        
        func testLmn() -> String {
            "SomeViewModel.testLmn|" + someObject.testAbc()
        }
        
        func testLmnNested() -> String {
            "SomeViewModel.testLmnNested|" + anotherObject.testXyz()
        }
    }

    class SomeViewController: ViewControllerObjectType {
        @Inject private var module: SampleModuleType
        
        private lazy var someObject: SomeObjectType = module.component()
        private lazy var anotherObject: AnotherObjectType = module.component()
        
        func testRst() -> String {
            "SomeViewController.testRst|" + someObject.testAbc()
        }
        
        func testRstNested() -> String {
            "SomeViewController.testRstNested|" + anotherObject.testXyz()
        }
    }

    struct WidgetWorker: WidgetWorkerType {
        private let store: WidgetStore
        private let remote: WidgetRemote
        
        init(store: WidgetStore, remote: WidgetRemote) {
            self.store = store
            self.remote = remote
        }
        
        func fetch(id: Int) -> String {
            store.fetch(id: id)
                + remote.fetch(id: id)
        }
    }

    struct WidgetNetworkRemote: WidgetRemote {
        private let httpService: HTTPServiceType
        
        init(httpService: HTTPServiceType) {
            self.httpService = httpService
        }
        
        func fetch(id: Int) -> String {
            "|MediaNetworkRemote.\(id)|"
        }
    }

    struct WidgetRealmStore: WidgetStore {
        
        func fetch(id: Int) -> String {
            "|MediaRealmStore.\(id)|"
        }
        
        func createOrUpdate(_ request: String) -> String {
            "MediaRealmStore.createOrUpdate\(request)"
        }
    }

    struct HTTPService: HTTPServiceType {
        
        func get(url: String) -> String {
            "HTTPService.get"
        }
        
        func post(url: String) -> String {
            "HTTPService.post"
        }
    }
}

// MARK: API

protocol WidgetModuleType {
    func component() -> WidgetWorkerType
    func component() -> WidgetRemote
    func component() -> WidgetStore
    func component() -> HTTPServiceType
    func test() -> String
}

protocol SampleModuleType {
    func component() -> SomeObjectType
    func component() -> AnotherObjectType
    func component() -> ViewModelObjectType
    func component() -> ViewControllerObjectType
    func test() -> String
}

protocol SomeObjectType {
    func testAbc() -> String
}

protocol AnotherObjectType {
    func testXyz() -> String
}

protocol ViewModelObjectType {
    func testLmn() -> String
    func testLmnNested() -> String
}

protocol ViewControllerObjectType {
    func testRst() -> String
    func testRstNested() -> String
}

protocol WidgetStore {
    func fetch(id: Int) -> String
    func createOrUpdate(_ request: String) -> String
}

protocol WidgetRemote {
    func fetch(id: Int) -> String
}

protocol WidgetWorkerType {
    func fetch(id: Int) -> String
}

protocol HTTPServiceType {
    func get(url: String) -> String
    func post(url: String) -> String
}
