//___FILEHEADER___

import SwiftUI
import ZamzamUI

struct ___VARIABLE_productName:identifier___View: View {
    @ObservedObject private var state: ___VARIABLE_productName:identifier___State
    private let interactor: ___VARIABLE_productName:identifier___Interactable?
    private let render: ___VARIABLE_productName:identifier___Renderable?

    init(state: ___VARIABLE_productName:identifier___State, interactor: ___VARIABLE_productName:identifier___Interactable?, render: ___VARIABLE_productName:identifier___Renderable?) {
        self.state = state
        self.interactor = interactor
        self.render = render
    }
    
    var body: some View {
        Text("Hello World")
            .onAppear {
                self.interactor?.fetch(
                    with: ___VARIABLE_productName:identifier___API.FetchRequest()
                )
            }
    }
}

// MARK: - Preview

#if DEBUG
struct ___VARIABLE_productName:identifier___View_Preview: PreviewProvider {
    
    static var previews: some View {
        ___VARIABLE_productName:identifier___View(
            state: AppPreview.___VARIABLE_productName:identifier___State,
            interactor: nil,
            render: nil
        ).previews
    }
}
#endif
