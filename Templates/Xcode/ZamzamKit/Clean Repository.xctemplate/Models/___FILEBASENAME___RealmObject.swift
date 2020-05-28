//___FILEHEADER___

import Foundation.NSDate
import RealmSwift

@objcMembers
class ___VARIABLE_productName:identifier___RealmObject: Object, ___VARIABLE_productName:identifier___Type {
    dynamic var id: Int = 0
    dynamic var createdAt: Date = .distantPast
    dynamic var modifiedAt: Date = .distantPast
    
    override static func primaryKey() -> String? {
        "id"
    }
}

// MARK: - Conversions

extension ___VARIABLE_productName:identifier___RealmObject {
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of ___VARIABLE_productName:identifier___ type.
    convenience init(from object: ___VARIABLE_productName:identifier___Type) {
        self.init()
        self.id = object.id
        self.createdAt = object.createdAt
        self.modifiedAt = object.modifiedAt
    }
    
    /// For converting to one type to another.
    ///
    /// - Parameter object: An instance of ___VARIABLE_productName:identifier___ type.
    convenience init?(from object: ___VARIABLE_productName:identifier___Type?) {
        guard let object = object else { return nil }
        self.init(from: object)
    }
}