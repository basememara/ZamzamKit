//___FILEHEADER___

struct ___VARIABLE_productName:identifier___Interactor: ___VARIABLE_productName:identifier___Interactable {
    let model: ___VARIABLE_productName:identifier___Mutable
}

extension ___VARIABLE_productName:identifier___Interactor {
    func fetch(with request: ___VARIABLE_productName:identifier___API.FetchRequest) async {
        let response = ___VARIABLE_productName:identifier___API.FetchResponse()
        await model.update(for: response)
    }
}
