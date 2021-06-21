//___FILEHEADER___

import ___VARIABLE_moduleName:identifier___Core
import ___VARIABLE_moduleName:identifier___UI

// MARK: - Namespace

enum ___VARIABLE_productName:identifier___API {}

// MARK: - Protocols

protocol ___VARIABLE_productName:identifier___Interactable: Interactor {
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest) async
}

protocol ___VARIABLE_productName:identifier___Presentable: Presenter {
    func display(for response: ___VARIABLE_productName:identifier___API.FetchResponse) async
    func display(error: ___VARIABLE_moduleName:identifier___Error) async
}

protocol ___VARIABLE_productName:identifier___Renderable: Render {}

// MARK: - Request / Response

extension ___VARIABLE_productName:identifier___API {
    struct FetchRequest {}
    struct FetchResponse {}
}
