//
//  MailSheet.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2021-08-16.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

#if os(iOS) && canImport(MessageUI)
import MessageUI
import SwiftUI

private struct MailView: UIViewControllerRepresentable {
    let item: MailItem

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.makeViewController(with: item)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private extension MailView {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        /// A standard interface for managing, editing, and sending an email message.
        func makeViewController(with request: MailItem) -> UIViewController {
            MFMailComposeViewController().apply {
                $0.mailComposeDelegate = self

                $0.setToRecipients(request.emails)

                if let subject = request.subject {
                    $0.setSubject(subject)
                }

                if let body = request.body {
                    $0.setMessageBody(body, isHTML: request.isHTML)
                }

                if let attachment = request.attachment {
                    $0.addAttachmentData(
                        attachment.data,
                        mimeType: attachment.mimeType,
                        fileName: attachment.fileName
                    )
                }
            }
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}

public struct MailItem: Identifiable, Equatable {
    public struct Attachment: Equatable {
        let data: Data
        let mimeType: String
        let fileName: String
    }

    public let id = UUID()
    let emails: [String]
    let subject: String?
    let body: String?
    let isHTML: Bool
    let attachment: Attachment?

    public init(
        emails: String...,
        subject: String? = nil,
        body: String? = nil,
        isHTML: Bool = true,
        attachment: Attachment? = nil
    ) {
        self.emails = emails
        self.subject = subject
        self.body = body
        self.isHTML = isHTML
        self.attachment = attachment
    }
}

public extension View {
    /// Presents a compose mail sheet using the given options for sending a message.
    ///
    /// If the current device is not able to send email, determined via `MFMailComposeViewController.canSendMail()`,
    /// an alert will notify the user of the failure.
    @ViewBuilder
    func sheet(mail item: Binding<MailItem?>) -> some View {
        if MFMailComposeViewController.canSendMail() {
            sheet(item: item) { item in
                MailView(item: item)
                    .ignoresSafeArea()
            }
        } else {
            alert(item: item) { _ in
                Alert(
                    title: Text("Could Not Send Email"),
                    message: Text("Your device could not send email.")
                )
            }
        }
    }
}
#endif
