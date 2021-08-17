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

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

private extension SafariView {
    struct URLItem: Identifiable {
        var id: String { url.absoluteString }
        let url: URL
    }
}

public extension View {
    /// Presents a Safari sheet using the given URL for browsing the web.
    func sheet(safari url: Binding<URL?>) -> some View {
        sheet(
            item: Binding<SafariView.URLItem?>(
                get: {
                    guard let url = url.wrappedValue else { return nil }
                    return SafariView.URLItem(url: url)
                },
                set: {
                    guard $0 == nil else { return }
                    url.wrappedValue = nil
                }
            )
        ) { item in
            SafariView(url: item.url)
                .ignoresSafeArea()
        }
    }
}
#endif
