//___FILEHEADER___

struct ___VARIABLE_productName:identifier___Presenter: ___VARIABLE_productName:identifier___Presentable {
    private(set) var model: ___VARIABLE_productName:identifier___Model
}

extension ___VARIABLE_productName:identifier___Presenter {
    @MainActor
    func display(for response: ___VARIABLE_productName:identifier___API.FetchResponse) async {
        
    }
}

extension ___VARIABLE_productName:identifier___Presenter {
    @MainActor
    func display(error: ___VARIABLE_moduleName:identifier___Error) async {
        model(\.error, ViewError(from: error))
    }
}