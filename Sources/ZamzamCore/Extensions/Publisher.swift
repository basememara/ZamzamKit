//
//  Publisher.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Combine

public extension Publisher where Failure == Never {
    /// Attaches a subscriber with closure-based behavior to a publisher that never fails.
    func sink(receiveValue: @escaping ((Self.Output) async throws -> Void)) -> AnyCancellable {
        sink { value in Task { try await receiveValue(value) } }
    }
}

public extension Optional where Wrapped: Combine.Publisher {
    /// Returns the wrapped value of a publisher or defaults to an empty publisher.
    func orEmpty() -> AnyPublisher<Wrapped.Output, Wrapped.Failure> {
        self?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }
}
