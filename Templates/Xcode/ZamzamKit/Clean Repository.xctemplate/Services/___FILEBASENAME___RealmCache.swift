//___FILEHEADER___

import Foundation
import ZamzamCore

public struct ___VARIABLE_productName:identifier___RealmCache: ___VARIABLE_productName:identifier___Cache {
    private let log: LogRepository
    
    public init(log: LogRepository) {
        self.log = log
    }
}

public extension ___VARIABLE_productName:identifier___RealmCache {
    
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest, completion: @escaping (Result<___VARIABLE_productName:identifier___, ZamzamError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            guard let object = realm.object(ofType: ___VARIABLE_productName:identifier___RealmObject.self, forPrimaryKey: request.id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = ___VARIABLE_productName:identifier___(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}

public extension ___VARIABLE_productName:identifier___RealmCache {
    
    func createOrUpdate(_ request: ___VARIABLE_productName:identifier___, completion: @escaping (Result<___VARIABLE_productName:identifier___, ZamzamError>) -> Void) {
        DispatchQueue.database.async {
            let realm: Realm
            
            do {
                realm = try Realm()
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            do {
                try realm.write {
                    realm.add(___VARIABLE_productName:identifier___RealmObject(from: request), update: .modified)
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(.databaseFailure(error))) }
                return
            }
            
            // Get refreshed object to return
            guard let object = realm.object(ofType: ___VARIABLE_productName:identifier___RealmObject.self, forPrimaryKey: request.id) else {
                DispatchQueue.main.async { completion(.failure(.nonExistent)) }
                return
            }
            
            let item = ___VARIABLE_productName:identifier___(from: object)
            
            DispatchQueue.main.async {
                completion(.success(item))
            }
        }
    }
}