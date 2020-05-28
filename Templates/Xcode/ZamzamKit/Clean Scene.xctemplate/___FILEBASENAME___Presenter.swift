//___FILEHEADER___

import ZamzamUI

struct ___VARIABLE_productName:identifier___Presenter: ___VARIABLE_productName:identifier___Presentable {
    private let state: Reducer<___VARIABLE_productName:identifier___Action>
    
    init(state: @escaping Reducer<___VARIABLE_productName:identifier___Action>) {
        self.state = state
    }
}

extension ___VARIABLE_productName:identifier___Presenter {

    func displayFetched(for response: ___VARIABLE_productName:identifier___API.FetchResponse) {
        state(.loadProfile(response.profile))
    }
    
    func displayFetched(error: ZamzamError) {
        let viewModel = ViewError(
            title: .localized(.genericErrorTitle),
            message: error.localizedDescription
        )
        
        state(.loadError(viewModel))
    }
}
