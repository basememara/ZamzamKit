//___FILEHEADER___

import ___VARIABLE_moduleName:identifier___Core
import ___VARIABLE_moduleName:identifier___UI
import SwiftUI

struct ___VARIABLE_productName:identifier___Presenter: ___VARIABLE_productName:identifier___Presentable {
    private(set) var model: ___VARIABLE_productName:identifier___Model
}

extension ___VARIABLE_productName:identifier___Presenter {
    func display(for response: ___VARIABLE_productName:identifier___API.FetchResponse) {
        
    }
}

extension ___VARIABLE_productName:identifier___Presenter {
    func display(error: ___VARIABLE_moduleName:identifier___Error) {
        model(\.error, ViewError(from: error))
    }
}

// MARK: - Localization

extension L10n {
    enum ___VARIABLE_productName:identifier___ {
        //static let title = LocalizedStringKey("___VARIABLE_productName:identifier____title")
    }
}

// MARK: Images

extension Image.Name {
    //static let myImage = Self(value: "my-image")
}
