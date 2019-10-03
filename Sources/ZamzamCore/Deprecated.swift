//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-10-01.
//

import Foundation

public extension Array {
    
    /// Remove array items in a thread-safe manner and executes
    /// the hander on each item of the array.
    ///
    /// The handler will be executed on each item in reverse order
    /// to ensure items that are appended to the array during this
    /// process does not interfere with the mutation.
    ///
    ///     var array = [1, 3, 5, 7, 9]
    ///     array.removeEach { print($0) }
    ///     // Prints "9" "7" "5" "3" "1"
    ///     array -> []
    ///
    /// - Parameter handler: Handler with array item that was popped.
    @available(*, deprecated, message: "Use atomic instead.")
    mutating func removeEach(handler: @escaping (Element) -> Void) {
        enumerated().reversed().forEach { handler(remove(at: $0.offset)) }
    }
}

public extension Array where Element: Equatable {

    /// Remove all duplicates from array.
    ///
    ///     var array = [1, 3, 3, 5, 7, 9]
    ///     array.removeDuplicates()
    ///     array // [1, 3, 5, 7, 9]
    @available(*, deprecated, message: "Avoid mutable objects. Use distinct instead.")
    mutating func removeDuplicates() {
        self = distinct
    }
}


public extension Collection where Iterator.Element == (String, Any) {
    
    /// Converts collection of objects to JSON string
    @available(*, deprecated, message: "Use codable instead.")
    var jsonString: String? {
        guard JSONSerialization.isValidJSONObject(self),
            let stringData = try? JSONSerialization.data(withJSONObject: self, options: []) else {
                return nil
        }
        
        return String(data: stringData, encoding: .utf8)
    }
}

public extension Dictionary where Key == String, Value: Any {
    
    /// Converts dictionary of objects to JSON string
    @available(*, deprecated, message: "Use codable instead.")
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        return String(bytes: jsonData, encoding: .utf8)
    }
}

public extension Sequence {

    /// Converts collection of objects to JSON string
    @available(*, deprecated, message: "Use codable instead.")
    var jsonString: String? {
        guard let data = self as? [[String: Any]],
            let stringData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
                return nil
        }
        
        return String(data: stringData, encoding: .utf8)
    }
}

public extension Date {

    /// Moves the date to the specified time zone.
    ///
    /// - Parameters:
    ///   - timeZone: The target time zone.
    ///   - calendar: Calendar used for calculation.
    /// - Returns: The shifted date using the time zone.
    @available(*, deprecated, message: "Open issue if needed.")
    func shift(to timeZone: TimeZone, for calendar: Calendar) -> Date {
        guard !timeZone.isCurrent else { return self }
        
        var dateComponents = calendar.dateComponents(
            Calendar.Component.full,
            from: self
        )
        
        // Shift from GMT using difference of current and specified time zone
        dateComponents.second = -timeZone.offsetFromCurrent

        return calendar.date(from: dateComponents) ?? self
    }
}

#if canImport(UIKit)
import UIKit

public extension UIFont {
    
    /// Specify font trait while leaving size intact.
    ///
    ///     textLabel?.font = textLabel?.font.with(traits: [.traitBold])
    @available(*, deprecated, message: "Open issue if needed.")
    func with(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
            return self
        }
        
        // https://stackoverflow.com/a/39999497
        return UIFont(descriptor: descriptor, size: 0)
    }
}
#endif

public extension Thread {
    typealias Block = @convention(block) () -> Void
    
    /// Execute block, used internally for async/sync functions.
    /// - Parameter block: Process to be executed.
    @objc private func execute(block: Block) {
        block()
    }
    
    /// Perform block on current thread asynchronously.
    /// - Parameter task: Process to be executed.
    @available(*, deprecated, message: "Open issue if needed.")
    func async(execute task: @escaping Block) {
        guard Thread.current != self else { return task() }
        perform(#selector(execute(block:)), on: self, with: task, waitUntilDone: false)
    }
    
    /// Perform block on current thread synchronously.
    /// - Parameter task: Perform block on current thread synchronously.
    @available(*, deprecated, message: "Open issue if needed.")
    func sync(execute task: @escaping Block) {
        guard Thread.current != self else { return task() }
        perform(#selector(execute(block:)), on: self, with: task, waitUntilDone: true)
    }
}
