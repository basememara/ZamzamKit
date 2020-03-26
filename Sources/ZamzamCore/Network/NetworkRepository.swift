//
//  NetworkProvider.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

public struct NetworkRepository: NetworkRepositoryType {
    private let service: NetworkService
    
    public init(service: NetworkService) {
        self.service = service
    }
}

public extension NetworkRepository {
    
    func send(with request: URLRequest, completion: @escaping (Result<NetworkAPI.Response, NetworkAPI.Error>) -> Void) {
        service.send(with: request, completion: completion)
    }
}

public extension NetworkRepository {
    
    func send(requests: URLRequest..., completion: @escaping ([Result<NetworkAPI.Response, NetworkAPI.Error>]) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        // Preallocate array size to retain order of requests
        var results: [Result<NetworkAPI.Response, NetworkAPI.Error>] = requests.map {
            .failure(NetworkAPI.Error(request: $0))
        }
        
        for (index, request) in requests.enumerated() {
            dispatchGroup.enter()
            
            service.send(with: request) {
                defer { dispatchGroup.leave() }
                results[index] = $0
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(results)
        }
    }
}
