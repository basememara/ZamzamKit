//___FILEHEADER___

import ZamzamCore

public struct ___VARIABLE_productName:identifier___NetworkStore: ___VARIABLE_productName:identifier___Store {
    private let log: LogWorkerType
    
    public init(log: LogWorkerType) {
        self.log = log
    }
}

public extension ___VARIABLE_productName:identifier___NetworkStore {
    
    func fetch(with request: ___VARIABLE_productName:identifier___Models.Request, completion: @escaping (Result<[___VARIABLE_productName:identifier___Type], ZamzamError>) -> Void) {
        apiSession.request(APIRouter.read___VARIABLE_productName:identifier___s(userID, request)) {
            // Handle errors if applicable
            guard let value = $0.value, $0.isSuccess else {
                let error = DataError(from: $0.error)
                self.log.error("An error occured while fetching ___VARIABLE_productName:identifier___: \($0.error?.serverDescription ?? "unknown")")
                return completion(.failure(error))
            }
            
            DispatchQueue.transform.async {
                do {
                    // Type used for decoding the server payload
                    struct ServerResponse: Decodable {
                        let objects: [___VARIABLE_productName:identifier___]
                    }
                    
                    // Parse response data
                    let payload = try JSONDecoder.default.decode(
                        NetworkModels.ServerResponse<ServerResponse>.self,
                        from: value.data
                    )
                    
                    guard let data = payload.data, payload.status == .success else {
                        self.log.error("An error occured while fetching ___VARIABLE_productName:identifier___, data nil or server status error: \(String(describing: payload.errors)).")
                        return DispatchQueue.main.async { completion(.failure(.unknownReason(nil))) }
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(data.objects))
                    }
                } catch {
                    self.log.error("An error occured while parsing ___VARIABLE_productName:identifier___: \(error).")
                    return DispatchQueue.main.async { completion(.failure(.parseFailure(error))) }
                }
            }
        }
    }
}
