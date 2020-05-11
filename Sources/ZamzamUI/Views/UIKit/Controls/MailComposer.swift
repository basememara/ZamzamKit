//
//  MailComposer.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2018-10-08.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import MessageUI

public protocol MailComposerDelegate: AnyObject {
    func mailComposer(didFinishWith result: MFMailComposeResult)
}

open class MailComposer: NSObject {
    private weak var delegate: MailComposerDelegate?
    private let styleNavigationBar: ((UINavigationBar) -> Void)?
    
    public init(
        delegate: MailComposerDelegate? = nil,
        styleNavigationBar: ((UINavigationBar) -> Void)? = nil
    ) {
        self.delegate = delegate
        self.styleNavigationBar = styleNavigationBar
    }
    
    /// Returns a Boolean indicating whether the current device is able to send email.
    open func canSendMail() -> Bool {
        MFMailComposeViewController.canSendMail()
    }
}

public extension MailComposer {
    
    /// A standard interface for managing, editing, and sending an email message.
    func makeViewController(email: String, subject: String? = nil, body: String? = nil, isHTML: Bool = true, attachment: Attachment? = nil) -> MFMailComposeViewController? {
        makeViewController(emails: [email], subject: subject, body: body, isHTML: isHTML, attachment: attachment)
    }
    
    /// A standard interface for managing, editing, and sending an email message.
    func makeViewController(emails: [String], subject: String?, body: String?, isHTML: Bool = true, attachment: Attachment? = nil) -> MFMailComposeViewController? {
        guard canSendMail() else { return nil }
        
        return MFMailComposeViewController().apply {
            $0.mailComposeDelegate = self
            
            $0.setToRecipients(emails)
            
            if let subject = subject {
                $0.setSubject(subject)
            }
            
            if let body = body {
                $0.setMessageBody(body, isHTML: isHTML)
            }
            
            if let attachment = attachment {
                $0.addAttachmentData(
                    attachment.data,
                    mimeType: attachment.mimeType,
                    fileName: attachment.fileName
                )
            }
            
            styleNavigationBar?($0.navigationBar)
        }
    }
}

// MARK: - Types

public extension MailComposer {
    typealias Attachment = (data: Data, mimeType: String, fileName: String)
}

// MARK: MFMailComposeViewControllerDelegate

extension MailComposer: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss {
            self.delegate?.mailComposer(didFinishWith: result)
        }
    }
}
#endif
