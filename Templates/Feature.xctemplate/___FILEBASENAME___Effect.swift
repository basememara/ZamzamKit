//___FILEHEADER___

struct ___VARIABLE_productName:identifier___Effect: ___VARIABLE_productName:identifier___Effectable {
    weak var model: ___VARIABLE_productName:identifier___Mutable?
}

extension ___VARIABLE_productName:identifier___Effect {
    func fetch() async {
        let response = ___VARIABLE_productName:identifier___API.FetchResponse(message: "Hello, world!")
        await model?.update(for: response)
    }
}
