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

/// A dependency containner that provides resolutions for object instances.
open class Container {
    /// Stored object instance closures.
    private var dependencies = [String: () -> Any]()
    
    /// DSL for declaring dependencies within the container initializer.
    @_functionBuilder public struct DependencyBuilder {
        public static func buildBlock(_ dependencies: Dependency...) -> [Dependency] {
            dependencies
        }
        
        public static func buildBlock(_ dependency: Dependency) -> Dependency {
            dependency
        }
    }
    
    /// Construct dependency resolutions.
    public init(@DependencyBuilder _ dependencies: () -> [Dependency]) {
        dependencies().forEach {
            add(String(describing: $0.type.self), dependency: $0.block)
        }
    }
    
    /// Construct dependency resolution.
    public init(@DependencyBuilder _ dependency: () -> Dependency) {
        let unwrap = dependency()
        add(String(describing: unwrap.type.self), dependency: unwrap.block)
    }
    
    /// Assigns the current container to the composition root.
    open func build() {
        Self.root = self
    }
    
    fileprivate init() {}
    deinit { dependencies.removeAll() }
}

private extension Container {
    /// Composition root container of dependencies.
    static var root = Container()
    
    /// Registers a specific type and its instantiating factory.
    func add<T>(_ key: String? = nil, dependency: @escaping () -> T) {
        let key = key ?? self.key(for: T.self)
        dependencies[key] = dependency
    }

    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    func resolve<T>() -> T {
        let key = self.key(for: T.self)
        
        guard let dependency: T = dependencies[key]?() as? T else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }
        
        return dependency
    }
    
    /// Generate key for storing object resolution.
    func key<T>(for type: T.Type) -> String {
        String(describing: T.self)
    }
}

// MARK: Public API

/// A type that contributes to the object graph.
public struct Dependency {
    fileprivate let block: () -> Any
    fileprivate let type: Any.Type
    
    public init<T>(_ block: @escaping () -> T) {
        self.block = block
        self.type = T.self
    }
}

/// Resolves an instance from the dependency injection container.
@propertyWrapper
public struct Inject<Value> {
    
    public var wrappedValue: Value {
        Container.root.resolve()
    }
    
    public init() {}
}
