//
//  FileServiceTests.swift
//  ZamzamKit
//
//  Created by Basem Emara on 1/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
@testable import ZamzamKit

class FileTests: XCTestCase {
    
    let fileName = "FileServiceTests.txt"
    let fileName2 = "FileServiceTests2.txt"
    
    override func setUp() {
        super.setUp()
        
        // Create blank files for testing
        do {
            try "Some text".write(toFile: fileInDocumentsDirectory(fileName), atomically: true, encoding: String.Encoding.utf8)
            try "Some text 2".write(toFile: fileInDocumentsDirectory(fileName2), atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Could not create files!")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Delete blank files after testing
        do {
            try FileManager.default.removeItem(atPath: fileInDocumentsDirectory(fileName))
            try FileManager.default.removeItem(atPath: fileInDocumentsDirectory(fileName2))
        } catch {
            print("Could not delete files!")
        }
    }
    
    func testGetDocumentPath() {
        let value = FileManager.default.getDocumentPath(fileName)
        
        XCTAssert(FileManager.default.fileExists(atPath: value),
            "The file location path for \(fileName) seems incorrect (file doesn't exist)")
    }
    
    func testGetDocumentPaths() {
        let value = FileManager.default.getDocumentPaths()
        let expectedValue = [
            fileInDocumentsDirectory(fileName),
            fileInDocumentsDirectory(fileName2)
        ]
        
        XCTAssert(value.contains(expectedValue[0]) && value.contains(expectedValue[1]),
            "The file paths for the document directory seems incorrect")
    }
    
    func testDownloadFile() {
        let expectation = self.expectation(description: "Download remote file")
        let url = "http://basememara.com/wp-content/uploads/2017/01/CapturFiles_125-150x150.png"
        
        FileManager.default.download(from: url) {
            XCTAssert($0.0 != nil)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
}
