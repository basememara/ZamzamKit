//___FILEHEADER___

import ZamzamUI

protocol ___VARIABLE_productName:identifier___Interactable: Interactor {
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest)
}

protocol ___VARIABLE_productName:identifier___Presentable: Presenter {
    func displayFetched(for response: ___VARIABLE_productName:identifier___API.FetchResponse)
    func displayFetched(error: ZamzamError)
}

protocol ___VARIABLE_productName:identifier___Renderable: Render {
    
}

// MARK: - Namespace

enum ___VARIABLE_productName:identifier___API {
    
    struct FetchRequest {
        
    }
    
    struct FetchResponse {
        
    }

    struct ViewModel {

    }
}
