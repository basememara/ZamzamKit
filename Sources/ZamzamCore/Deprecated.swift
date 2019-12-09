//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-12-08.
//

import Foundation

@available(*, deprecated, message: "Use constructor injection instead.")
public class Dependencies {
    /// Stored object instance factories.
    private var modules: [String: Module] = [:]
    
    private init() {}
    deinit { modules.removeAll() }
    
    /// Registers a specific type and its instantiating factory.
    private func add(module: Module) {
        modules[module.name] = module
    }
    
    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    private func resolve<T>(for name: String? = nil) -> T {
        let name = name ?? String(describing: T.self)
        
        guard let component: T = modules[name]?.resolve() as? T else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }
        
        return component
    }
    
    /// Composition root container of dependencies.
    fileprivate static var root = Dependencies()
    
    /// Construct dependency resolutions.
    public convenience init(@ModuleBuilder _ modules: () -> [Module]) {
        self.init()
        modules().forEach { add(module: $0) }
    }
    
    /// Construct dependency resolution.
    public convenience init(@ModuleBuilder _ module: () -> Module) {
        self.init()
        add(module: module())
    }
    
    /// Assigns the current container to the composition root.
    public func build() {
        // Used later in property wrapper
        Self.root = self
    }
    
    /// DSL for declaring modules within the container dependency initializer.
    public @_functionBuilder struct ModuleBuilder {
        public static func buildBlock(_ modules: Module...) -> [Module] { modules }
        public static func buildBlock(_ module: Module) -> Module { module }
    }
}

@available(*, deprecated, message: "Use constructor injection instead.")
public struct Module {
    fileprivate let name: String
    fileprivate let resolve: () -> Any
    
    public init<T>(_ name: String? = nil, _ resolve: @escaping () -> T) {
        self.name = name ?? String(describing: T.self)
        self.resolve = resolve
    }
}

@available(*, deprecated, message: "Use constructor injection instead.")
@propertyWrapper
public class Inject<Value> {
    private let name: String?
    private var storage: Value?
    
    public var wrappedValue: Value {
        storage ?? {
            let value: Value = Dependencies.root.resolve(for: name)
            storage = value // Reuse instance for later
            return value
        }()
    }
    
    public init() {
        self.name = nil
    }
    
    public init(_ name: String) {
        self.name = name
    }
}
