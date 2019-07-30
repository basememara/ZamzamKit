//___FILEHEADER___

import ZamzamKit

public struct ___VARIABLE_productName:identifier___Worker: ___VARIABLE_productName:identifier___WorkerType {
    private let store: ___VARIABLE_productName:identifier___Store
    
    public init(store: ___VARIABLE_productName:identifier___Store) {
        self.store = store
    }
}

public extension ___VARIABLE_productName:identifier___Worker {
    
    func fetch(with request: ___VARIABLE_productName:identifier___Models.Request, completion: @escaping (Result<[___VARIABLE_productName:identifier___Type], ZamzamError>) -> Void) {
        store.fetch(with: request, completion: completion)
    }
}