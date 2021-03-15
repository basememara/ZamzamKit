//___FILEHEADER___

import SwiftUI

struct ___VARIABLE_productName:identifier___View: View {
    // Injected dependencies
    @ObservedObject private(set) var model: ___VARIABLE_productName:identifier___Model
    let interactor: ___VARIABLE_productName:identifier___Interactable?
    let scene: ___VARIABLE_productName:identifier___Renderable?

    var body: some View {
        Text("___VARIABLE_productName:identifier___")
    }
}

// MARK: - Previews

#if DEBUG
struct ___VARIABLE_productName:identifier___View_Previews: PreviewProvider {
    static var previews: some View {
        AppPreviews {
            NavigationView {
                ___VARIABLE_productName:identifier___View(
                    model: ___VARIABLE_productName:identifier___Model(),
                    interactor: nil,
                    scene: nil
                )
            }
        }
    }
}
#endif
