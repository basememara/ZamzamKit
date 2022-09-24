//___FILEHEADER___

import ___VARIABLE_moduleName:identifier___Core
import ___VARIABLE_moduleName:identifier___UI
import SwiftUI

final class ___VARIABLE_productName:identifier___Model: ObservableObject, ___VARIABLE_productName:identifier___Mutable {
    @Published private(set) var message: String?
    @Published var error: ViewError?
    lazy var effect: ___VARIABLE_productName:identifier___Effectable? = ___VARIABLE_productName:identifier___Effect(model: self)
}

// MARK: - Mutations

extension ___VARIABLE_productName:identifier___Model {
    @MainActor
    func update(for response: ___VARIABLE_productName:identifier___API.FetchResponse) async {
        message = response.message
    }
}

extension ___VARIABLE_productName:identifier___Model {
    @MainActor
    func update(error: ___VARIABLE_moduleName:identifier___Error) async {
        self.error = ViewError(from: error)
    }
}
