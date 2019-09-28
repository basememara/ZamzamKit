//___FILEHEADER___

import ZamzamKit

// Namespace for scene
public enum ___VARIABLE_productName:identifier___API {}

protocol ___VARIABLE_productName:identifier___Actionable: AppActionable { // Interactor
    func fetch(with request: ___VARIABLE_productName:identifier___API.Request)
}

protocol ___VARIABLE_productName:identifier___Presentable: AppPresentable { // Presenter
    func presentFetched(for response: ___VARIABLE_productName:identifier___API.Response)
    func presentFetched(error: ZamzamError)
}

protocol ___VARIABLE_productName:identifier___Displayable: class, AppDisplayable { // Controller
    func displayFetched(with viewModel: ___VARIABLE_productName:identifier___API.ViewModel)
}

protocol ___VARIABLE_productName:identifier___Routable: AppRoutable { // Router
    
}

public extension ___VARIABLE_productName:identifier___API {
    
    struct Request {
        
    }
    
    struct Response {
        
    }

    struct ViewModel {

    }
}
