//
//  Obfuscator.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-11-24.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation

/// Conceals and reveals an obfuscated string.
///
///     let obfuscator = Obfuscator(salt: "App ID, or value that does not change")
///
///     let scrambled = obfuscator.conceal(secret: "your_secret_string_here")
///     // scrambled == [34, 17, 93, 37, 28, 21, 72, 23, 20, 22, 72, 123, 98, 127, 87, 92, 94, 83, 73, 116]
///
///     let service = MyService(apiKey: obfuscator.reveal(secret: scrambled))
///     // service.apiKey == "your_secret_string_here"
///
/// The value is not encrypted, only harder to pull out of a decompiled binary.
public struct Obfuscator: Sendable {
    private let salt: String

    /// An instance used to conceal and reveal strings.
    /// - Parameter salt: The salt used to obfuscate and reveal the string.
    public init(salt: String) {
        self.salt = salt
    }
}

public extension Obfuscator {
    #if DEBUG
    /// Returns the bytes of the string combined with the salt, to paste into the source in place of the string.
    ///
    /// Exists in debug builds only, and prints the salt, the string and the bytes to the console. With an empty salt
    /// the bytes are the string's own and nothing is printed.
    func conceal(secret string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        guard length > 0 else { return text }
        var encrypted = [UInt8]()

        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % length])
        }

        print(["Salt: \(salt)", "String: \(string)", "Obfuscated: \(encrypted)"].joined(separator: "\n"))
        return encrypted
    }
    #endif

    /// Returns the string that `conceal(secret:)` turned into the bytes, given the same salt.
    ///
    /// Returns `nil` when the result isn't UTF-8, which the wrong salt can cause. With an empty salt the bytes are read as they are.
    func reveal(secret bytes: [UInt8]) -> String? {
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        guard length > 0 else { return String(bytes: bytes, encoding: .utf8) }
        var decrypted = [UInt8]()

        for value in bytes.enumerated() {
            decrypted.append(value.element ^ cipher[value.offset % length])
        }

        return String(bytes: decrypted, encoding: .utf8)
    }
}
