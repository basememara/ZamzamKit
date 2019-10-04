//
//  A Swift micro-library that provides lightweight dependency injection.
//
//  Inspired by:
//  https://dagger.dev
//  https://github.com/hmlongco/Resolver
//  https://github.com/InsertKoinIO/koin
//
//  Created by Basem Emara on 2019-09-06.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation

/// A dependency collection that resolves object instances through the `@Inject` property wrapper.
///
///     class AppDelegate: UIResponder, UIApplicationDelegate {
///
///         private let dependencies = Dependencies {
///             Module { WidgetModule() as WidgetModuleType }
///             Module { SampleModule() as SampleModuleType }
///         }
///
///         override init() {
///             super.init()
///             dependencies.build()
///         }
///     }
///
///     // Some time later...
///
///     class ViewController: UIViewController {
///
///         @Inject private var widgetService: WidgetServiceType
///         @Inject private var sampleService: SampleServiceType
///
///         override func viewDidLoad() {
///             super.viewDidLoad()
///
///             print(widgetService.test())
///             print(sampleService.test())
///         }
///     }
public class Dependencies {
    /// Stored object instance factories.
    private var modules: [String: Module] = [:]
    
    private init() {}
    deinit { modules.removeAll() }
}

private extension Dependencies {
    
    /// Registers a specific type and its instantiating factory.
    func add(module: Module) {
        modules[module.name] = module
    }

    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    func resolve<T>(for name: String? = nil) -> T {
        let name = name ?? String(describing: T.self)
        
        guard let component: T = modules[name]?.resolve() as? T else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }
        
        return component
    }
}

// MARK: - Public API

public extension Dependencies {
    /// Composition root container of dependencies.
    fileprivate static var root = Dependencies()
    
    /// Construct dependency resolutions.
    convenience init(@ModuleBuilder _ modules: () -> [Module]) {
        self.init()
        modules().forEach { add(module: $0) }
    }
    
    /// Construct dependency resolution.
    convenience init(@ModuleBuilder _ module: () -> Module) {
        self.init()
        add(module: module())
    }
    
    /// Assigns the current container to the composition root.
    func build() {
        // Used later in property wrapper
        Self.root = self
    }
    
    /// DSL for declaring modules within the container dependency initializer.
    @_functionBuilder struct ModuleBuilder {
        public static func buildBlock(_ modules: Module...) -> [Module] { modules }
        public static func buildBlock(_ module: Module) -> Module { module }
    }
}

/// A type that contributes to the object graph.
public struct Module {
    fileprivate let name: String
    fileprivate let resolve: () -> Any
    
    public init<T>(_ name: String? = nil, _ resolve: @escaping () -> T) {
        self.name = name ?? String(describing: T.self)
        self.resolve = resolve
    }
}

/// Resolves an instance from the dependency injection container.
@propertyWrapper
public struct Inject<Value> {
    private let name: String?
    
    public var wrappedValue: Value {
        Dependencies.root.resolve(for: name)
    }
    
    public init() {
        self.name = nil
    }
    
    public init(_ name: String) {
        self.name = name
    }
}
