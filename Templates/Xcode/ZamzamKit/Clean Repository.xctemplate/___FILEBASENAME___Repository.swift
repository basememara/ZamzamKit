//___FILEHEADER___

public struct ___VARIABLE_productName:identifier___Repository {
    private let service: ___VARIABLE_productName:identifier___Service
    
    public init(service: ___VARIABLE_productName:identifier___Service) {
        self.service = service
    }
}

public extension ___VARIABLE_productName:identifier___Repository {
    
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest, completion: @escaping (Result<[___VARIABLE_productName:identifier___], ZamzamError>) -> Void) {
        service.fetch(with: request, completion: completion)
    }
}