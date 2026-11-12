//
//  SafariSheet.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-11-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if os(iOS) && canImport(SafariServices)
import SafariServices
import SwiftUI

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

public extension View {
    /// Presents a Safari sheet using the given URL for browsing the web.
    ///
    ///     struct ContentView: View {
    ///         @State private var linkURL: URL?
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Button(action: { linkURL = "https://apple.com" })
    ///                     Text("Open link")
    ///                 }
    ///                 .sheet(safari: $linkURL)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - url: A binding to whether the Safari browser should be presented. A URL that isn't HTTP or HTTPS
    ///     presents nothing, since the browser can't open it.
    func sheet(safari url: Binding<URL?>, onDismiss: (() -> Void)? = nil) -> some View {
        sheet(
            isPresented: Binding<Bool>(
                get: { url.wrappedValue?.isWebPage == true },
                set: {
                    guard !$0 else { return }
                    url.wrappedValue = nil
                }
            ),
            onDismiss: onDismiss
        ) {
            if let url = url.wrappedValue, url.isWebPage {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}

private extension URL {
    /// Whether Safari's in-app browser can open the URL; it raises an exception for any scheme but HTTP and HTTPS.
    var isWebPage: Bool {
        ["http", "https"].contains(scheme?.lowercased())
    }
}
#endif
