//___FILEHEADER___

import ___VARIABLE_moduleName:identifier___Core
import ___VARIABLE_moduleName:identifier___UI

// MARK: - Namespace

enum ___VARIABLE_productName:identifier___API {}

// MARK: - Protocols

protocol ___VARIABLE_productName:identifier___Interactable {
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest) async
}

protocol ___VARIABLE_productName:identifier___Mutable: AnyObject {
    func update(for response: ___VARIABLE_productName:identifier___API.FetchResponse) async
    func update(error: ___VARIABLE_moduleName:identifier___Error) async
}

protocol ___VARIABLE_productName:identifier___Destination {}

// MARK: - Request / Response

extension ___VARIABLE_productName:identifier___API {
    struct FetchRequest {}
    struct FetchResponse {}
}
