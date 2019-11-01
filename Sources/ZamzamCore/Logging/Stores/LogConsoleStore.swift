//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-28.
//

import Foundation

/// Sends a message to the IDE console.
public struct LogConsoleStore: LogStore {
    private let minLevel: LogAPI.Level
    private let queue = DispatchQueue(label: "io.zamzam.LogConsoleStore", qos: .utility)
    
    public init(minLevel: LogAPI.Level) {
        self.minLevel = minLevel
    }
}

public extension LogConsoleStore {
    
    func verbose(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .verbose else { return }
        queue.async { print("💜 VERBOSE \(self.output(message, path, function, line, context))") }
    }
    
    func debug(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .debug else { return }
        queue.async { print("💚 DEBUG \(self.output(message, path, function, line, context))") }
    }
    
    func info(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .info else { return }
        queue.async { print("💙 INFO \(self.output(message, path, function, line, context))") }
    }
    
    func warning(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .warning else { return }
        queue.async { print("💛 WARNING \(self.output(message, path, function, line, context))") }
    }
    
    func error(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        guard minLevel <= .error else { return }
        queue.async { print("❤️ ERROR \(self.output(message, path, function, line, context))") }
    }
}

private extension LogConsoleStore {
    
    func output(_ message: String, _ path: String, _ function: String, _ line: Int, _ context: [String: Any]?) -> String {
        "\(URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent).\(function):\(line) - \(message)"
    }
}
