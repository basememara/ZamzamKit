//
//  UNNotificationAttachment.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2/7/17.
//  Copyright © 2017 Zamzam. All rights reserved.
//

import UserNotifications

public extension UNNotificationAttachment {

    /// Converts a resource from the Internet to a user notification attachment.
    ///
    /// - Parameters:
    ///   - link: The remote HTTP path to the resource.
    ///   - identifier: The identitifer of the user notification attachment.
    ///   - completion: The callback with the constucted user notification attachment.
    static func download(from link: String, identifier: String? = nil, completion: @escaping (Result<UNNotificationAttachment, ZamzamError>) -> Void) {
        FileManager.default.download(from: link) {
            guard $2 == nil else { return completion(.failure($2 != nil ? .other($2!) : .general)) }
            
            guard let url = $0, let attachment = try? UNNotificationAttachment(identifier: identifier ?? link, url: url)
                else { return completion(.failure(.invalidData)) }
            
            completion(.success(attachment))
        }
    }
}
