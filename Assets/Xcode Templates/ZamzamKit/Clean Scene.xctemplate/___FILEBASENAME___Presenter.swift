//___FILEHEADER___

import ZamzamKit

struct ___VARIABLE_productName:identifier___Presenter: ___VARIABLE_productName:identifier___Presentable {
    private weak var viewController: ___VARIABLE_productName:identifier___Displayable?
    
    init(viewController: ___VARIABLE_productName:identifier___Displayable) {
        self.viewController = viewController
    }
}

extension ___VARIABLE_productName:identifier___Presenter {

    func presentFetched(for response: ___VARIABLE_productName:identifier___API.Response) {
        
    }
    
    func presentFetched(error: ZamzamError) {
        let viewModel = AppModels.Error(
            title: .localized(.genericErrorTitle),
            message: error.localizedDescription
        )
        
        viewController?.display(error: viewModel)
    }
}
