//
//  FileServiceTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import ZamzamCore

#if !os(tvOS)
class FileTests: XCTestCase {
    private let fileName = "FileServiceTests.txt"
    private let fileName2 = "FileServiceTests2.txt"

    override func setUp() {
        super.setUp()

        // Create blank files for testing
        do {
            try "Some text".write(toFile: fileInDirectory(fileName), atomically: true, encoding: .utf8)
            try "Some text 2".write(toFile: fileInDirectory(fileName2), atomically: true, encoding: .utf8)
        } catch {
            print("Could not create files!")
        }
    }

    override func tearDown() {
        super.tearDown()

        // Delete blank files after testing
        do {
            try FileManager.default.removeItem(atPath: fileInDirectory(fileName))
            try FileManager.default.removeItem(atPath: fileInDirectory(fileName2))
        } catch {
            print("Could not delete files!")
        }
    }
}

extension FileTests {
    func testGetDocumentPath() {
        let value = FileManager.default.path(of: fileName, from: .downloadsDirectory)

        XCTAssert(
            FileManager.default.fileExists(atPath: value),
            "The file location path for \(fileName) seems incorrect (file doesn't exist)"
        )
    }

    func testDownloadFile() {
        let promise = expectation(description: #function)
        let url = "https://zamzam.io/wp-content/uploads/2021/02/logo-1.png"

        FileManager.default.download(from: url) { url, _, _ in
            guard let url = url else {
                XCTFail("URL should not be nil")
                return
            }

            XCTAssert(FileManager.default.fileExists(atPath: url.path))
            XCTAssertNotNil(UIImage(contentsOfFile: url.path))
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)
    }
}

#if os(iOS)
extension FileTests {
    func testGetDocumentPaths() {
        let value = FileManager.default.paths(from: .downloadsDirectory)
        let expectedValue = [
            fileInDirectory(fileName),
            fileInDirectory(fileName2)
        ]

        XCTAssert(
            value.contains(expectedValue[0]) && value.contains(expectedValue[1]),
            "The file paths for the document directory seems incorrect"
        )
    }
}
#endif

private extension FileTests {
    func fileInDirectory(_ filename: String) -> String {
        return FileManager.default
            .urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
            .path
    }
}
#endif
