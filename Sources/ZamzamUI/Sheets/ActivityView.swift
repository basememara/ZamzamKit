//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by Basem Emara on 2021-08-29.
//

#if os(iOS)
import SwiftUI

/// A view that you use to offer standard services from your app.
///
/// Present the view from the `.sheet` modifier.
///
///     struct ContentView: View {
///         @State private var isSharePresenting = false
///
///         var body: some View {
///             VStack {
///                 Button {
///                     isSharePresenting.toggle()
///                 } label: {
///                     Text("Share with a friend")
///                 }
///             }
///             .sheet(isPresented: $isSharePresenting) {
///                 let item = ["Check out the app!", "https://itunes.apple.com/app/id123"]
///                 ActivityView(activityItems: item)
///             }
///         }
///     }
///
public struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    public init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif
