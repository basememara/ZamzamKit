//
//  BottomSheet.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-08-29.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import SwiftUI

#if os(iOS)
@available(iOS, obsoleted: 16.0)
private struct BottomSheet<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let detents: [UISheetPresentationController.Detent]
    let prefersGrabberVisible: Bool
    let preferredCornerRadius: CGFloat?
    let content: (() -> Content)?
    let onDismiss: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard isPresented else {
            guard uiViewController.presentedViewController == context.coordinator.controller else { return }
            uiViewController.presentedViewController?.dismiss(animated: true, completion: onDismiss)
            return
        }

        guard let content = content?(), uiViewController.presentedViewController == nil else { return }

        let hostingController = UIHostingController(rootView: content)
        hostingController.presentationController?.delegate = context.coordinator

        if let presentationController = hostingController.presentationController as? UISheetPresentationController {
            presentationController.detents = detents
            presentationController.prefersGrabberVisible = prefersGrabberVisible
            presentationController.preferredCornerRadius = preferredCornerRadius
        }

        // Store reference to compare later for dismissal in multi bottom sheet scenarios
        context.coordinator.controller = hostingController

        uiViewController.present(hostingController, animated: true)
    }
}

private extension BottomSheet {
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        private let parent: BottomSheet
        var controller: UIViewController?

        init(parent: BottomSheet) {
            self.parent = parent
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            guard parent.isPresented else { return }
            parent.isPresented = false
            parent.onDismiss?()
        }
    }
}

public extension View {
    /// Presents a sheet when a binding to a `Boolean` value that you provide is true.
    ///
    ///     struct ShowLicenseAgreement: View {
    ///         @State private var isShowingSheet = false
    ///
    ///         var body: some View {
    ///             Button {
    ///                 isShowingSheet.toggle()
    ///             } label: {
    ///                 Text("Show License Agreement")
    ///             }
    ///             .bottomSheet(isPresented: $isShowingSheet, onDismiss: didDismiss) {
    ///                 VStack {
    ///                     Text("License Agreement")
    ///                         .font(.title)
    ///                         .padding(50)
    ///                     Text("Terms and conditions go here.")
    ///                         .padding(50)
    ///                     Button("Dismiss") {
    ///                         isShowingSheet.toggle()
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    /// Bottom sheet presentation specify a sheet's size based on a detent, a height where a sheet naturally rests.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a `Boolean` value that determines whether to present
    ///                  the sheet that you create in the modifier's `content` closure.
    ///   - detents: An object that represents a height where a sheet naturally rests.
    ///   - prefersGrabberVisible: A Boolean value that determines whether the sheet shows a grabber at the top.
    ///   - preferredCornerRadius: The corner radius that the sheet attempts to present with.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
    @ViewBuilder
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        prefersGrabberVisible: Bool = true,
        preferredCornerRadius: CGFloat? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        background(
            BottomSheet(
                isPresented: isPresented,
                detents: detents,
                prefersGrabberVisible: prefersGrabberVisible,
                preferredCornerRadius: preferredCornerRadius,
                content: content,
                onDismiss: onDismiss
            )
        )
    }
}

public extension View {
    /// Presents a bottom sheet using the given item as a data source for the sheet's content.
    ///
    /// Use this method when you need to present a bottom sheet view with content
    /// from a custom data source. The example below shows a custom data source
    /// `InventoryItem` that the `content` closure uses to populate the display
    /// the bottom sheet shows to the user:
    ///
    ///     struct ShowPartDetail: View {
    ///         @State private var inventoryItem: InventoryItem?
    ///
    ///         var body: some View {
    ///             List((1..<6)) { index in
    ///                 Button("Part Details #\(index)") {
    ///                     inventoryItem = InventoryItem(
    ///                         id: "\(index)",
    ///                         partNumber: "Z-1234-\(index)",
    ///                         quantity: .random(in: 0..<100),
    ///                         name: "Widget \(index)"
    ///                     )
    ///                 }
    ///             }
    ///             .bottomSheet(item: $inventoryItem, onDismiss: didDismiss) { item in
    ///                 List {
    ///                     Text("Part Number: \(item.partNumber)")
    ///                     Text("Name: \(item.name)")
    ///                     Text("Quantity On-Hand: \(item.quantity)")
    ///                     Button("Dismiss") {
    ///                         inventoryItem = nil
    ///                     }
    ///                     .frame(maxWidth: .infinity)
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///
    ///         struct InventoryItem: Identifiable {
    ///             var id: String
    ///             let partNumber: String
    ///             let quantity: Int
    ///             let name: String
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the sheet.
    ///     When `item` is non-`nil`, the system passes the item's content to
    ///     the modifier's closure. You display this content in a sheet that you
    ///     create that the system displays to the user. If `item` changes,
    ///     the system dismisses the sheet and replaces it with a new one
    ///     using the same process.
    ///   - detents: An object that represents a height where a sheet naturally rests.
    ///   - prefersGrabberVisible: A Boolean value that determines whether the sheet shows a grabber at the top.
    ///   - preferredCornerRadius: The corner radius that the sheet attempts to present with.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure returning the content of the sheet.
    @ViewBuilder
    func bottomSheet<Item, Content>(
        item: Binding<Item?>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        prefersGrabberVisible: Bool = true,
        preferredCornerRadius: CGFloat? = nil,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Item: Identifiable, Content: View {
        bottomSheet(
            isPresented: Binding<Bool>(
                get: { item.wrappedValue != nil },
                set: {
                    guard !$0 else { return }
                    item.wrappedValue = nil
                }
            ),
            detents: detents,
            prefersGrabberVisible: prefersGrabberVisible,
            preferredCornerRadius: preferredCornerRadius,
            onDismiss: onDismiss,
            content: { item.wrappedValue.map(content) }
        )
    }
}

// MARK: - Previews

#if DEBUG
struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        Sample1View()
        Sample2View()
    }

    private struct Sample1View: View {
        @State private var dismissedStatus = "Content here..."
        @State private var isShowingSheet = false

        var body: some View {
            Button {
                isShowingSheet.toggle()
            } label: {
                Text("Show License Agreement")
            }
            .bottomSheet(isPresented: $isShowingSheet) {
                VStack {
                    Text("License Agreement")
                        .font(.title)
                        .padding(50)
                    Text("Terms and conditions go here.")
                        .padding(50)
                    Button("Dismiss") {
                        isShowingSheet.toggle()
                    }
                }
            }
        }
    }

    private struct Sample2View: View {
        @State private var inventoryItem: InventoryItem?

        var body: some View {
            List((1..<6)) { index in
                Button("Part Details #\(index)") {
                    inventoryItem = InventoryItem(
                        id: "\(index)",
                        partNumber: "Z-1234-\(index)",
                        quantity: .random(in: 0..<100),
                        name: "Widget \(index)"
                    )
                }
            }
            .bottomSheet(item: $inventoryItem) { item in
                List {
                    Text("Part Number: \(item.partNumber)")
                    Text("Name: \(item.name)")
                    Text("Quantity On-Hand: \(item.quantity)")
                    Button("Dismiss") {
                        inventoryItem = nil
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }

        struct InventoryItem: Identifiable {
            var id: String
            let partNumber: String
            let quantity: Int
            let name: String
        }
    }
}
#endif
#endif
