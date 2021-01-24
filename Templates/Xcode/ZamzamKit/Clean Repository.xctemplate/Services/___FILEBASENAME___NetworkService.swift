//___FILEHEADER___

import Foundation
import ZamzamCore

public struct ___VARIABLE_productName:identifier___NetworkService: ___VARIABLE_productName:identifier___Service {
    private let networkManager: NetworkManager
    private let constants: Constants
    private let log: LogManager
    
    public init(
        networkManager: NetworkManager,
        constants: Constants,
        log: LogManager
    ) {
        self.networkManager = networkManager
        self.constants = constants
        self.log = log
    }
}

public extension ___VARIABLE_productName:identifier___NetworkService {
    
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest, completion: @escaping (Result<[___VARIABLE_productName:identifier___], ZamzamError>) -> Void) {
        let urlRequest: URLRequest = .read___VARIABLE_productName:identifier___(id: request.id, constants: constants)
        
        networkManager.send(with: urlRequest) {
            // Handle errors
            guard case .success = $0 else {
                // Handle no existing data
                if $0.error?.statusCode == 404 {
                    completion(.failure(.nonExistent))
                    return
                }
                
                self.log.error("An error occured while fetching the ___VARIABLE_productName:identifier___: \(String(describing: $0.error)).")
                completion(.failure(ZamzamError(from: $0.error)))
                return
            }
            
            // Ensure available
            guard case let .success(item) = $0, let data = item.data else {
                completion(.failure(.nonExistent))
                return
            }
            
            DispatchQueue.transform.async {
                do {
                    // Type used for decoding the server payload
                    struct ServerResponse: Decodable {
                        let ___VARIABLE_productName:identifier___: ___VARIABLE_productName:identifier___
                    }
                    
                    // Parse response data
                    let payload = try JSONDecoder.default.decode(ServerResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(payload.___VARIABLE_productName:identifier___))
                    }
                } catch {
                    self.log.error("An error occured while parsing the ___VARIABLE_productName:identifier___: \(error).")
                    DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                    return
                }
            }
        }
    }
}

// MARK: - Requests

private extension URLRequest {
    
    static func read___VARIABLE_productName:identifier___(id: Int, constants: Constants) -> URLRequest {
        URLRequest(
            url: constants.baseURL
                .appendingPathComponent(constants.baseREST)
                .appendingPathComponent("___VARIABLE_productName:identifier___/\(id)"),
            method: .get
        )
    }
} 
