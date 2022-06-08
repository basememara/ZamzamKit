//
//  Publisher.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2021-01-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import Combine

public extension Optional where Wrapped: Combine.Publisher {
    /// Returns the wrapped value of a publisher or defaults to an empty publisher.
    func orEmpty() -> AnyPublisher<Wrapped.Output, Wrapped.Failure> {
        self?.eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
    }
}
