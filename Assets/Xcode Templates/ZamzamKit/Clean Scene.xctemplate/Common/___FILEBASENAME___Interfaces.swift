//___FILEHEADER___

import ZamzamKit

protocol ___VARIABLE_productName:identifier___BusinessLogic: AppBusinessLogic { // Interactor
    func fetch(with request: ___VARIABLE_productName:identifier___Models.Request)
}

protocol ___VARIABLE_productName:identifier___Presentable: AppPresentable { // Presenter
    func presentFetched(for response: ___VARIABLE_productName:identifier___Models.Response)
    func presentFetched(error: ZamzamError)
}

protocol ___VARIABLE_productName:identifier___Displayable: class, AppDisplayable { // Controller
    func displayFetched(with viewModel: ___VARIABLE_productName:identifier___Models.ViewModel)
}

protocol ___VARIABLE_productName:identifier___Routable: AppRoutable { // Router
    
}
