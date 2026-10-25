//
//  LogServiceFile.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2026-10-25.
//  Copyright © 2026 Zamzam Inc. All rights reserved.
//

import Foundation

/// Appends entries to a file on the device, such as a log to attach to a support request.
///
/// Once the file passes 2 MB on watchOS, or 5 MB elsewhere, it becomes the newest of up to 10 numbered
/// archives and a new file starts; the oldest archive is deleted. A write that fails drops its entry rather
/// than the app. Use one service per file.
public struct LogServiceFile: LogService {
    public let minLevel: LogAPI.Level
    private let subsystem: String
    private let sessionKeys: Set<String>
    private let writer: Writer

    /// - Parameter sessionKeys: The session context attributes repeated on every entry.
    public init(minLevel: LogAPI.Level, subsystem: String, fileURL: URL, sessionKeys: Set<String> = []) {
        self.init(
            minLevel: minLevel,
            subsystem: subsystem,
            fileURL: fileURL,
            sessionKeys: sessionKeys,
            maxFileSize: Self.maxFileSize,
            maxArchives: Self.maxArchives
        )
    }

    init(minLevel: LogAPI.Level, subsystem: String, fileURL: URL, sessionKeys: Set<String> = [], maxFileSize: UInt64, maxArchives: Int) {
        self.minLevel = minLevel
        self.subsystem = subsystem
        self.sessionKeys = sessionKeys
        self.writer = Writer(fileURL: fileURL, maxFileSize: maxFileSize, maxArchives: maxArchives)
    }
}

private extension LogServiceFile {
    #if os(watchOS)
    static let maxFileSize: UInt64 = 2_000_000
    #else
    static let maxFileSize: UInt64 = 5_000_000
    #endif

    static let maxArchives = 10
}

public extension LogServiceFile {
    func write(
        _ level: LogAPI.Level,
        with message: String,
        file: String,
        function: String,
        line: Int,
        error: Error?,
        context: [String: any CustomStringConvertible & Sendable],
        sessionContext: [String: any CustomStringConvertible & Sendable]
    ) {
        let time = Date.now.formatted(Date.ISO8601FormatStyle(includingFractionalSeconds: true, timeZone: .current))

        guard let prefix = level.prefix(time: time, subsystem: subsystem) else { return }

        let context = context.merging(sessionContext.filter { sessionKeys.contains($0.key) }) { current, _ in current }
        writer.append("\(prefix) \(format(message, file, function, line, error, context))\n")
    }

    /// The current file and the newest archive, oldest entry first, including every entry written before the call.
    func contents() -> Data {
        writer.contents()
    }
}

private extension LogServiceFile {
    /// `@unchecked Sendable`: its mutable state is touched only on `queue`, which is serial.
    final class Writer: @unchecked Sendable {
        private let fileURL: URL
        private let archivesNewestFirst: [URL]
        private let maxFileSize: UInt64
        private let queue = DispatchQueue(label: "io.zamzam.ZamzamCore.LogServiceFile", qos: .utility)

        private var handle: FileHandle?

        init(fileURL: URL, maxFileSize: UInt64, maxArchives: Int) {
            self.fileURL = fileURL
            self.archivesNewestFirst = (1...maxArchives).map { fileURL.appendingPathExtension("\($0)") }
            self.maxFileSize = maxFileSize
        }

        func append(_ line: String) {
            queue.async { [self] in
                guard let handle = handle ?? open() else { return }

                do {
                    try handle.write(contentsOf: Data(line.utf8))
                } catch {
                    close()
                    return
                }

                if ((try? handle.offset()) ?? 0) >= maxFileSize {
                    rotate()
                }
            }
        }

        func contents() -> Data {
            queue.sync {
                var data = archivesNewestFirst.first.flatMap { try? Data(contentsOf: $0) } ?? Data()
                data.append((try? Data(contentsOf: fileURL)) ?? Data())
                return data
            }
        }

        private func open() -> FileHandle? {
            let fileManager = FileManager.default

            if !fileManager.fileExists(atPath: fileURL.path) {
                try? fileManager.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
                fileManager.createFile(atPath: fileURL.path, contents: nil)
            }

            guard let opened = try? FileHandle(forWritingTo: fileURL) else { return nil }

            guard (try? opened.seekToEnd()) != nil else {
                try? opened.close()
                return nil
            }

            handle = opened
            return opened
        }

        private func close() {
            try? handle?.close()
            handle = nil
        }

        private func rotate() {
            let fileManager = FileManager.default
            let files = [fileURL] + archivesNewestFirst
            close()

            // `moveItem` won't overwrite, so each step clears its own destination: a file that can't be
            // removed then costs that one archive instead of stopping every rotation after it
            zip(files.dropLast(), files.dropFirst())
                .reversed()
                .forEach { newer, older in
                    try? fileManager.removeItem(at: older)
                    try? fileManager.moveItem(at: newer, to: older)
                }
        }
    }
}
