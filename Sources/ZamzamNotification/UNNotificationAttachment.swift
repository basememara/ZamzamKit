//
//  UNNotificationAttachment.swift
//  ZamzamLocation
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
    ///         guard case let .success(attachment) = $0 else {
    ///             log.error("Could not download the remote resource (\(urlString)): \($0.error?.debugDescription).")
    ///             return
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
    static func download(
        from urlString: String,
        identifier: String? = nil,
        completion: @escaping (Result<UNNotificationAttachment, ZamzamError>) -> Void
    ) {
        FileManager.default.download(from: urlString) { url, _, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }

            guard let url = url, let attachment = try? UNNotificationAttachment(identifier: identifier ?? urlString, url: url) else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(attachment))
        }
    }
}
#endif
