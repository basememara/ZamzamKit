//
//  NetworkProvider.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

public struct NetworkProvider: NetworkProviderType {
    private let store: NetworkStore
    
    public init(store: NetworkStore) {
        self.store = store
    }
}

public extension NetworkProvider {
    
    func send(with request: URLRequest, completion: @escaping (Result<NetworkAPI.Response, NetworkError>) -> Void) {
        store.send(with: request, completion: completion)
    }
}

