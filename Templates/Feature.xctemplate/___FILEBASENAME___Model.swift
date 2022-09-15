//___FILEHEADER___

import SwiftUI
import ___VARIABLE_moduleName:identifier___Core
import ___VARIABLE_moduleName:identifier___UI

@MainActor
final class ___VARIABLE_productName:identifier___Model: ObservableObject, ___VARIABLE_productName:identifier___Mutable {
    @Published var error: ViewError?
}

// MARK: - Mutations

extension ___VARIABLE_productName:identifier___Model {
    func update(for response: ___VARIABLE_productName:identifier___API.FetchResponse) async {

    }
}

extension ___VARIABLE_productName:identifier___Model {
    func update(error: ___VARIABLE_moduleName:identifier___Error) async {
        self.error = ViewError(from: error)
    }
}
