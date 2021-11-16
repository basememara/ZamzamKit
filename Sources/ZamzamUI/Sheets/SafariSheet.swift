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

extension View {
    /// Presents a Safari sheet using the given URL for browsing the web.
    func sheet(safari url: Binding<URL?>) -> some View {
        sheet(
            isPresented: Binding<Bool>(
                get: { url.wrappedValue != nil },
                set: {
                    guard !$0 else { return }
                    url.wrappedValue = nil
                }
            )
        ) {
            if let url = url.wrappedValue {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}
#endif
