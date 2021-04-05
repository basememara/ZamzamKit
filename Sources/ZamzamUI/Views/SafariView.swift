//
//  SafariView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-11-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if os(iOS) && canImport(SafariServices)
import SafariServices
import SwiftUI

public struct SafariView: UIViewControllerRepresentable {
    let url: URL

    public init(for url: URL) {
        self.url = url
    }

    public func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
#endif
