//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-28.
//

import Foundation

public struct LoggerConsoleStore: LoggerStore {
    public init() {}
}

public extension LoggerConsoleStore {
    
    func verbose(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        print("💜 VERBOSE \(output(message, path, function, line, context))")
    }
    
    func debug(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        print("💚 DEBUG \(output(message, path, function, line, context))")
    }
    
    func info(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        print("💙 INFO \(output(message, path, function, line, context))")
    }
    
    func warn(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        print("💛 WARNING \(output(message, path, function, line, context))")
    }
    
    func error(_ message: String, path: String = #file, function: String = #function, line: Int = #line, context: [String: Any]? = nil) {
        print("❤️ ERROR \(output(message, path, function, line, context))")
    }
}

private extension LoggerConsoleStore {
    
    func output(_ message: String, _ path: String, _ function: String, _ line: Int, _ context: [String: Any]?) -> String {
        "\(URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent).\(function):\(line) - \(message)"
    }
}
