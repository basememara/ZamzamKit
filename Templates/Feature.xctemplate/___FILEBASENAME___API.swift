//___FILEHEADER___

import ___VARIABLE_moduleName:identifier___Core

// MARK: - Namespace

enum ___VARIABLE_productName:identifier___API {}

// MARK: - Protocols

protocol ___VARIABLE_productName:identifier___Effectable {
    func fetch() async
}

protocol ___VARIABLE_productName:identifier___Mutable: AnyObject {
    func update(for response: ___VARIABLE_productName:identifier___API.FetchResponse) async
    func update(error: ___VARIABLE_moduleName:identifier___Error) async
}

// MARK: - Request / Response

extension ___VARIABLE_productName:identifier___API {
    struct FetchResponse {
        let message: String
    }
}
