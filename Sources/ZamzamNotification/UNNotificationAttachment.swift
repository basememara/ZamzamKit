//
//  UNNotificationAttachment.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/7/17.
//  Copyright © 2017 Zamzam Inc. All rights reserved.
//

#if !os(tvOS)
import UserNotifications
import ZamzamCore

public extension UNNotificationAttachment {

    /// Retrieves a remote image from the web and converts to a user notification attachment.
    ///
    ///     UNNotificationAttachment.download(from: urlString) {
    ///         guard $0.isSuccess, let attachment = $0.value else {
    ///             return log.error("Could not download the remote resource (\(urlString)): \($0.error.debugDescription).")
    ///         }
    ///
    ///         UNUserNotificationCenter.current().add(
    ///             body: "This is the body",
    ///             attachments: [attachment]
    ///         )
    ///     }
    ///
    /// - Parameters:
    ///   - urlString: The remote HTTP path to the resource.
    ///   - identifier: The identitifer of the user notification attachment.
    ///   - completion: The callback with the constucted user notification attachment.
    static func download(from urlString: String, identifier: String? = nil, completion: @escaping (Result<UNNotificationAttachment, ZamzamError>) -> Void) {
        FileManager.default.download(from: urlString) {
            guard $2 == nil else {
                return completion(.failure($2 != nil ? .other($2 ?? ZamzamError.invalidData) : .general))
            }
            
            guard let url = $0, let attachment = try? UNNotificationAttachment(identifier: identifier ?? urlString, url: url) else {
                return completion(.failure(.invalidData))
            }
            
            completion(.success(attachment))
        }
    }
}
#endif
