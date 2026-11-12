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
/// Note this does not encrypt the value but simply makes it harder to extract from decompiled code.
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
    /// This method obfuscates the string passed in using the salt that was used when the Obfuscator was initialized.
    /// Scoped within the debug macro and commented out so this code does not get compiled in production binaries.
    ///
    /// - Parameter string: The string to obfuscate
    /// - Returns: The obfuscated string in a byte array, or the string's own bytes when the salt is empty.
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

    /// This method reveals the original string from the obfuscated byte array passed in.
    /// The salt must be the same as the one used to encrypt it in the first place.
    ///
    /// - Parameter bytes: The byte array to reveal.
    /// - Returns: The original string, read from the bytes as they are when the salt is empty.
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
