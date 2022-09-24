//___FILEHEADER___

import SwiftUI

struct ___VARIABLE_productName:identifier___View: View {
    @StateObject var model = ___VARIABLE_productName:identifier___Model()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(model.message ?? "Loading...")
        }
        .padding()
        .task { await fetch() }
    }
}

// MARK: - Actions

private extension ___VARIABLE_productName:identifier___View {
    func fetch() async {
        await model.effect?.fetch()
    }
}

// MARK: - Localization

/*private extension Text {
    static let navigationTitle = Text(
        "navigation_title",
        tableName: "___VARIABLE_productName:identifier___",
        comment: "The navigation bar title for the screen"
    )
}*/

// MARK: - Previews

#if DEBUG
struct ___VARIABLE_productName:identifier___View_Previews: PreviewProvider {
    static var previews: some View {
        ___VARIABLE_productName:identifier___View()
    }
}
#endif
