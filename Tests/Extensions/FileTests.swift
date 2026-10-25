//
//  FileServiceTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Testing
import ZamzamCore

// A class so the fixture files can be removed in `deinit`. Names are unique per
// instance because Swift Testing runs tests in parallel against one file system.
final class FileTests {
    private let fileName = "FileServiceTests-\(UUID().uuidString).txt"
    private let fileName2 = "FileServiceTests2-\(UUID().uuidString).txt"

    init() {
        do {
            try "Some text".write(toFile: fileInDirectory(fileName), atomically: true, encoding: .utf8)
            try "Some text 2".write(toFile: fileInDirectory(fileName2), atomically: true, encoding: .utf8)
        } catch {
            Issue.record("Could not create the fixture files: \(error)")
        }
    }

    deinit {
        try? FileManager.default.removeItem(atPath: fileInDirectory(fileName))
        try? FileManager.default.removeItem(atPath: fileInDirectory(fileName2))
    }
}

extension FileTests {
    @Test
    func getDocumentPath() {
        let value = FileManager.default.path(of: fileName, from: .downloadsDirectory)

        #expect(FileManager.default.fileExists(atPath: value))
    }
}

#if os(iOS)
extension FileTests {
    @Test
    func getDocumentPaths() {
        let value = FileManager.default.paths(from: .downloadsDirectory)
        let expectedValue = [
            fileInDirectory(fileName),
            fileInDirectory(fileName2)
        ]

        #expect(value.contains(expectedValue[0]) && value.contains(expectedValue[1]))
    }
}
#endif

private extension FileTests {
    func fileInDirectory(_ filename: String) -> String {
        FileManager.default
            .urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
            .path
    }
}
