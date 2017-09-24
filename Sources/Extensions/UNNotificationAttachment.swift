//
//  UNNotificationAttachment.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/7/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UserNotifications

@available(iOS 10.0, *)
public extension UNNotificationAttachment {

    /// Converts a resource from the Internet to a user notification attachment.
    ///
    /// - Parameters:
    ///   - link: The remote HTTP path to the resource.
    ///   - identifier: The identitifer of the user notification attachment.
    ///   - complete: The callback with the constucted user notification attachment.
    static func download(from link: String, identifier: String? = nil, complete: @escaping (Result<UNNotificationAttachment>) -> Void) {
        FileManager.default.download(from: link) {
            guard $2 == nil else { return complete(.failure($2 ?? ZamzamError.general)) }
            
            guard let url = $0, let attachment = try? UNNotificationAttachment(identifier: identifier ?? link, url: url)
                else { return complete(.failure(ZamzamError.invalidData)) }
            
            complete(.success(attachment))
        }
    }
}
