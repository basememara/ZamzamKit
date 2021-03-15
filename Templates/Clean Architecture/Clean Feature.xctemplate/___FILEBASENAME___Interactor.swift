//___FILEHEADER___

struct ___VARIABLE_productName:identifier___Interactor: ___VARIABLE_productName:identifier___Interactable {
    let presenter: ___VARIABLE_productName:identifier___Presentable
}

extension ___VARIABLE_productName:identifier___Interactor {
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest) {
        let response = ___VARIABLE_productName:identifier___API.FetchResponse()
        presenter.display(for: response)
    }
}
