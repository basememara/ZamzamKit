//
//  NetworkProvider.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

public struct NetworkManager {
    private let service: NetworkService
    private let adapter: URLRequestAdapter?
    
    /// Creates a network wrapper to handle HTTP requests.
    ///
    /// - Parameters:
    ///   - service: A service that performs the underlying HTTP request with a session.
    ///   - adapter: Inspects and adapts the specified `URLRequest` in some manner and returns the new request.
    public init(service: NetworkService, adapter: URLRequestAdapter? = nil) {
        self.service = service
        self.adapter = adapter
    }
}

public extension NetworkManager {
    
    /// Creates a task that retrieves the contents of a URL based on the specified request object, and calls a handler upon completion.
    ///
    ///     let request = URLRequest(
    ///         url: URL(string: "https://httpbin.org/get")!,
    ///         method: .get,
    ///         parameters: [
    ///             "abc": 123,
    ///             "def": "test456",
    ///             "xyz": true
    ///         ],
    ///         headers: [
    ///             "Abc": "test123",
    ///             "Def": "test456",
    ///             "Xyz": "test789"
    ///         ]
    ///     )
    ///
    ///     let networkManager = NetworkManager(
    ///         service: NetworkURLSessionService()
    ///     )
    ///
    ///     networkManager.send(with: request) { result in
    ///         switch result {
    ///         case let .success(response):
    ///             response.data
    ///             response.headers
    ///             response.statusCode
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - request: A network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load request is complete.
    func send(with request: URLRequest, completion: @escaping (NetworkAPI.URLResult) -> Void) {
        let request = adapter?.adapt(request) ?? request
        service.send(with: request, completion: completion)
    }
}

public extension NetworkManager {
    
    /// Create tasks that retrieves the contents of a URL based on the specified request objects, and calls a handler upon completion with the result matching the index of the request.
    ///
    ///     let request1 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/get")!,
    ///         method: .get
    ///     )
    ///
    ///     let request2 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/post")!,
    ///         method: .post
    ///     )
    ///
    ///     networkManager.send(requests: request1, request2) { first, second in
    ///         switch result.0 {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///
    ///         switch first {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///
    ///         switch second {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - request1: The first network request object that provides the URL, parameters, headers, and so on.
    ///   - request2: The second network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load requests have all completed.
    func send(
        requests request1: URLRequest,
        _ request2: URLRequest,
        completion: @escaping ((NetworkAPI.URLResult, NetworkAPI.URLResult)
    ) -> Void) {
        send(requests: request1, request2) { result in
            completion((result[0], result[1]))
        }
    }
    
    /// Create tasks that retrieves the contents of a URL based on the specified request objects, and calls a handler upon completion with the result matching the index of the request.
    ///
    ///     let request1 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/get")!,
    ///         method: .get
    ///     )
    ///
    ///     let request2 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/post")!,
    ///         method: .post
    ///     )
    ///
    ///     let request3 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/delete")!,
    ///         method: .delete
    ///     )
    ///
    ///     networkManager.send(requests: request1, request2, request3) { first, second, third in
    ///         switch first {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///
    ///         switch second {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///
    ///         switch third {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - request1: The first network request object that provides the URL, parameters, headers, and so on.
    ///   - request2: The second network request object that provides the URL, parameters, headers, and so on.
    ///   - request3: The third network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load requests have all completed.
    func send(
        requests request1: URLRequest,
        _ request2: URLRequest,
        _ request3: URLRequest,
        completion: @escaping ((NetworkAPI.URLResult, NetworkAPI.URLResult, NetworkAPI.URLResult)) -> Void
    ) {
        send(requests: request1, request2, request3) { result in
            completion((result[0], result[1], result[2]))
        }
    }
    
    /// Create tasks that retrieves the contents of a URL based on the specified request objects, and calls a handler upon completion with the result matching the index of the request.
    ///
    ///     let request1 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/get")!,
    ///         method: .get
    ///     )
    ///
    ///     let request2 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/post")!,
    ///         method: .post
    ///     )
    ///
    ///     let request3 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/delete")!,
    ///         method: .delete
    ///     )
    ///
    ///     let request4 = URLRequest(
    ///         url: URL(string: "https://httpbin.org/patch")!,
    ///         method: .patch
    ///     )
    ///
    ///     networkManager.send(requests: request1, request2, request3, request4) { first, second, third, fourth in
    ///         switch first {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///
    ///         switch second {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///
    ///         switch third {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///
    ///         switch fourth {
    ///         case let .success(response):
    ///             response.data
    ///         case let .failure(error):
    ///             error.statusCode
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - request1: The first network request object that provides the URL, parameters, headers, and so on.
    ///   - request2: The second network request object that provides the URL, parameters, headers, and so on.
    ///   - request3: The third network request object that provides the URL, parameters, headers, and so on.
    ///   - request4: The fourth network request object that provides the URL, parameters, headers, and so on.
    ///   - completion: The completion handler to call when the load requests have all completed.
    func send(
        requests request1: URLRequest,
        _ request2: URLRequest,
        _ request3: URLRequest,
        _ request4: URLRequest,
        completion: @escaping ((NetworkAPI.URLResult, NetworkAPI.URLResult, NetworkAPI.URLResult, NetworkAPI.URLResult)) -> Void
    ) {
        send(requests: request1, request2, request3, request4) { result in
            completion((result[0], result[1], result[2], result[3]))
        }
    }
}

private extension NetworkManager {
    
    func send(requests: URLRequest..., completion: @escaping ([NetworkAPI.URLResult]) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        // Preallocate array size to retain order of requests
        var results: [NetworkAPI.URLResult] = requests.map {
            .failure(NetworkAPI.Error(request: $0))
        }
        
        for (index, request) in requests.enumerated() {
            dispatchGroup.enter()
            
            let request = adapter?.adapt(request) ?? request
            
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

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension NetworkManager {
    
    /// Creates a task that retrieves the contents of a URL based on the specified request object, and calls a handler upon completion.
    ///
    /// - Parameters:
    ///   - request: A network request object that provides the URL, parameters, headers, and so on.
    /// - Returns: A publisher that provides a single response from the request.
    func send(with request: URLRequest) -> Future<NetworkAPI.Response, NetworkAPI.Error> {
        Future<NetworkAPI.Response, NetworkAPI.Error> {
            send(with:request, completion: $0)
        }
    }
}
#endif
