//
//  LogServiceFileTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2026-10-25.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import Foundation
import Testing
@testable import ZamzamCore

struct LogServiceFileTests {
    private let folder = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    private var fileURL: URL { folder.appendingPathComponent("app.log") }

    @Test
    func entriesAreAppendedInOrder() {
        defer { try? FileManager.default.removeItem(at: folder) }
        let service = makeService()

        write("first", to: service, level: .info)
        write("second", to: service, level: .warning)

        let lines = lines(of: service)
        #expect(messages(of: service) == ["first", "second"])
        #expect(lines.first?.contains("INFO [Test]") == true)
        #expect(lines.last?.contains("WARNING [Test]") == true)
    }

    @Test
    func concurrentWritesKeepEveryEntryWhole() {
        defer { try? FileManager.default.removeItem(at: folder) }
        let service = makeService()
        let count = 500

        DispatchQueue.concurrentPerform(iterations: count) { write("entry \($0)", to: service) }

        #expect(Set(messages(of: service)) == Set((0..<count).map { "entry \($0)" }))
    }

    @Test
    func aFullFileBecomesTheNewestArchiveAndTheOldestIsDeleted() {
        defer { try? FileManager.default.removeItem(at: folder) }
        let count = 100
        let service = makeService(maxFileSize: 1_000, maxArchives: 3)

        (0..<count).forEach { write("entry \($0)", to: service) }
        _ = service.contents()

        let archives = (1...4).map { fileURL.appendingPathExtension("\($0)") }
        #expect(archives.map { FileManager.default.fileExists(atPath: $0.path) } == [true, true, true, false])

        let onDisk = ([archives[2], archives[1], archives[0], fileURL])
            .flatMap { messages(in: (try? Data(contentsOf: $0)) ?? Data()) }
            .compactMap { Int($0.replacingOccurrences(of: "entry ", with: "")) }
        #expect(onDisk.last == count - 1)
        #expect(onDisk == Array((onDisk.first ?? 0)..<count))
        #expect(onDisk.first != 0)
    }

    @Test
    func anArchiveThatCantBeReplacedDoesntStopRotation() throws {
        let stuck = fileURL.appendingPathExtension("3")
        defer {
            try? FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: stuck.path)
            try? FileManager.default.removeItem(at: folder)
        }
        try FileManager.default.createDirectory(at: stuck, withIntermediateDirectories: true)
        try Data().write(to: stuck.appendingPathComponent("locked"))
        try FileManager.default.setAttributes([.posixPermissions: 0o500], ofItemAtPath: stuck.path)
        let service = makeService(maxFileSize: 1_000, maxArchives: 3)

        (0..<100).forEach { write("entry \($0)", to: service) }

        let longestLine = lines(of: service).map { $0.utf8.count + 1 }.max() ?? 0
        let current = (try? Data(contentsOf: fileURL)) ?? Data()
        #expect(current.count < 1_000 + longestLine)
    }

    @Test
    func contentsHoldTheCurrentFileAndTheNewestArchive() {
        defer { try? FileManager.default.removeItem(at: folder) }
        let service = makeService(maxFileSize: 1_000, maxArchives: 3)

        (0..<100).forEach { write("entry \($0)", to: service) }
        let contents = service.contents()

        let newest = (try? Data(contentsOf: fileURL.appendingPathExtension("1"))) ?? Data()
        let current = (try? Data(contentsOf: fileURL)) ?? Data()
        #expect(!newest.isEmpty)
        #expect(contents == newest + current)
    }

    @Test
    func aNewServiceAppendsToTheExistingFile() {
        defer { try? FileManager.default.removeItem(at: folder) }
        let earlier = makeService()
        write("before", to: earlier)
        #expect(messages(of: earlier) == ["before"])

        let service = makeService()
        write("after", to: service)

        #expect(messages(of: service) == ["before", "after"])
    }

    @Test
    func onlyTheChosenSessionAttributesAreWritten() {
        defer { try? FileManager.default.removeItem(at: folder) }
        let service = makeService(sessionKeys: ["app_version"])

        write("entry", to: service, sessionContext: ["app_version": "1.0", "user_id": "42"])

        let line = lines(of: service).first ?? ""
        #expect(line.contains("app_version"))
        #expect(!line.contains("user_id"))
    }

    @Test
    func aFileThatCantBeWrittenDropsEntries() throws {
        defer { try? FileManager.default.removeItem(at: folder) }
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let blocker = folder.appendingPathComponent("blocker")
        try Data().write(to: blocker)

        let service = LogServiceFile(minLevel: .verbose, subsystem: "Test", fileURL: blocker.appendingPathComponent("app.log"))
        write("dropped", to: service)

        #expect(service.contents().isEmpty)
    }
}

private extension LogServiceFileTests {
    func makeService(maxFileSize: UInt64 = 1_000_000, maxArchives: Int = 10, sessionKeys: Set<String> = []) -> LogServiceFile {
        LogServiceFile(
            minLevel: .verbose,
            subsystem: "Test",
            fileURL: fileURL,
            sessionKeys: sessionKeys,
            maxFileSize: maxFileSize,
            maxArchives: maxArchives
        )
    }

    func write(
        _ message: String,
        to service: LogServiceFile,
        level: LogAPI.Level = .info,
        sessionContext: [String: any CustomStringConvertible & Sendable] = [:]
    ) {
        service.write(level, with: message, file: #fileID, function: #function, line: #line, error: nil, context: [:], sessionContext: sessionContext)
    }

    func lines(of service: LogServiceFile) -> [String] {
        lines(in: service.contents())
    }

    func lines(in data: Data) -> [String] {
        String(decoding: data, as: UTF8.self).split(separator: "\n").map(String.init)
    }

    func messages(of service: LogServiceFile) -> [String] {
        messages(in: service.contents())
    }

    func messages(in data: Data) -> [String] {
        lines(in: data).compactMap { $0.components(separatedBy: " - ").last }
    }
}
