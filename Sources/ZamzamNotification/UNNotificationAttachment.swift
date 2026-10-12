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
    /// Retrieves a remote file, such as an image, as a user notification attachment.
    ///
    ///     let attachment = try await UNNotificationAttachment.download(from: url)
    ///     try await UNUserNotificationCenter.current().add(body: "This is the body", attachments: [attachment])
    ///
    /// - Parameters:
    ///   - url: The remote HTTP URL of the resource.
    ///   - identifier: The identifier of the attachment; the URL's string by default.
    static func download(from url: URL, identifier: String? = nil) async throws -> UNNotificationAttachment {
        let file = try await FileManager.default.download(from: url)
        return try UNNotificationAttachment(identifier: identifier ?? url.absoluteString, url: file)
    }
}
#endif
