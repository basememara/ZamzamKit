//___FILEHEADER___

// MARK: - Services

public protocol ___VARIABLE_productName:identifier___Service {
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest, completion: @escaping (Result<[___VARIABLE_productName:identifier___], ZamzamError>) -> Void)
}

// MARK: - Cache

public protocol ___VARIABLE_productName:identifier___Cache {
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest, completion: @escaping (Result<[___VARIABLE_productName:identifier___], ZamzamError>) -> Void)
    func createOrUpdate(_ request: ___VARIABLE_productName:identifier___, completion: @escaping (Result<[___VARIABLE_productName:identifier___], ZamzamError>) -> Void)
}

// MARK: - Namespace

public enum ___VARIABLE_productName:identifier___API {
    
    public struct FetchRequest {
        
    }
    
    public struct FetchResponse {
        
    }
}