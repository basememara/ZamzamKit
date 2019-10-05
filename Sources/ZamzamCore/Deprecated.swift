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

@available(*, deprecated, message: "Use `AppAPI` instead.")
public enum AppModels {
    
    public struct Error {
        public let title: String?
        public let message: String?
        
        public init(title: String? = nil, message: String? = nil) {
            self.title = title
            self.message = message
        }
    }
}

/// A thread-safe array.
@available(*, deprecated, message: "Use generic `Synchronized<Value>` instead.")
public class SynchronizedArray<Element> {
    private let queue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).SynchronizedArray", attributes: .concurrent)
    private var array = [Element]()
    
    public init() { }
    
    public convenience init(_ array: [Element]) {
        self.init()
        self.array = array
    }
}

public extension SynchronizedArray {
    
    /// The first element of the collection.
    var first: Element? {
        var result: Element?
        queue.sync { result = self.array.first }
        return result
    }

    /// The last element of the collection.
    var last: Element? {
        var result: Element?
        queue.sync { result = self.array.last }
        return result
    }

    /// The number of elements in the array.
    var count: Int {
        var result = 0
        queue.sync { result = self.array.count }
        return result
    }

    /// A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool {
        var result = false
        queue.sync { result = self.array.isEmpty }
        return result
    }

    /// A textual representation of the array and its elements.
    var description: String {
        var result = ""
        queue.sync { result = self.array.description }
        return result
    }
    
    /// Returns the first element of the sequence that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The first element of the sequence that satisfies predicate, or nil if there is no element that satisfies predicate.
    func first(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync { result = self.array.first(where: predicate) }
        return result
    }
    
    /// Returns the last element of the sequence that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The last element of the sequence that satisfies predicate, or nil if there is no element that satisfies predicate.
    func last(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync { result = self.array.last(where: predicate) }
        return result
    }
    
    /// Returns an array containing, in order, the elements of the sequence that satisfy the given predicate.
    ///
    /// - Parameter isIncluded: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element should be included in the returned array.
    /// - Returns: An array of the elements that includeElement allowed.
    func filter(_ isIncluded: @escaping (Element) -> Bool) -> SynchronizedArray {
        var result: SynchronizedArray?
        queue.sync { result = SynchronizedArray(self.array.filter(isIncluded)) }
        return result ?? self
    }
    
    /// Returns the first index in which an element of the collection satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: The index of the first element for which predicate returns true. If no elements in the collection satisfy the given predicate, returns nil.
    func firstIndex(where predicate: (Element) -> Bool) -> Int? {
        var result: Int?
        queue.sync { result = self.array.firstIndex(where: predicate) }
        return result
    }
    
    /// Returns the elements of the collection, sorted using the given predicate as the comparison between elements.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
    /// - Returns: A sorted array of the collection’s elements.
    func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> SynchronizedArray {
        var result: SynchronizedArray?
        queue.sync { result = SynchronizedArray(self.array.sorted(by: areInIncreasingOrder)) }
        return result ?? self
    }
    
    /// Returns an array containing the results of mapping the given closure over the sequence’s elements.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-nil results of calling transform with each element of the sequence.
    func map<ElementOfResult>(_ transform: @escaping (Element) -> ElementOfResult) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync { result = self.array.map(transform) }
        return result
    }
    
    /// Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-nil results of calling transform with each element of the sequence.
    func compactMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync { result = self.array.compactMap(transform) }
        return result
    }
    
    /// Returns the result of combining the elements of the sequence using the given closure.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value. initialResult is passed to nextPartialResult the first time the closure is executed.
    ///   - nextPartialResult: A closure that combines an accumulating value and an element of the sequence into a new accumulating value, to be used in the next call of the nextPartialResult closure or returned to the caller.
    /// - Returns: The final accumulated value. If the sequence has no elements, the result is initialResult.
    func reduce<ElementOfResult>(_ initialResult: ElementOfResult, _ nextPartialResult: @escaping (ElementOfResult, Element) -> ElementOfResult) -> ElementOfResult {
        var result: ElementOfResult?
        queue.sync { result = self.array.reduce(initialResult, nextPartialResult) }
        return result ?? initialResult
    }
    
    /// Returns the result of combining the elements of the sequence using the given closure.
    ///
    /// - Parameters:
    ///   - initialResult: The value to use as the initial accumulating value.
    ///   - updateAccumulatingResult: A closure that updates the accumulating value with an element of the sequence.
    /// - Returns: The final accumulated value. If the sequence has no elements, the result is initialResult.
    func reduce<ElementOfResult>(into initialResult: ElementOfResult, _ updateAccumulatingResult: @escaping (inout ElementOfResult, Element) -> Void) -> ElementOfResult {
        var result: ElementOfResult?
        queue.sync { result = self.array.reduce(into: initialResult, updateAccumulatingResult) }
        return result ?? initialResult
    }

    /// Calls the given closure on each element in the sequence in the same order as a for-in loop.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a parameter.
    func forEach(_ body: (Element) -> Void) {
        queue.sync { self.array.forEach(body) }
    }
    
    /// Returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: true if the sequence contains an element that satisfies predicate; otherwise, false.
    func contains(where predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(where: predicate) }
        return result
    }
    
    /// Returns a Boolean value indicating whether every element of a sequence satisfies a given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element satisfies a condition.
    /// - Returns: true if the sequence contains only elements that satisfy predicate; otherwise, false.
    func allSatisfy(_ predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self.array.allSatisfy(predicate) }
        return result
    }

    /// Adds a new element at the end of the array.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - element: The element to append to the array.
    ///   - completion: The block to execute when completed.
    func append(_ element: Element, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            self.array.append(element)
            DispatchQueue.main.async { completion?() }
        }
    }

    /// Adds new elements at the end of the array.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - element: The elements to append to the array.
    ///   - completion: The block to execute when completed.
    func append(_ elements: [Element], completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            self.array += elements
            DispatchQueue.main.async { completion?() }
        }
    }

    /// Inserts a new element at the specified position.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - element: The new element to insert into the array.
    ///   - index: The position at which to insert the new element.
    ///   - completion: The block to execute when completed.
    func insert(_ element: Element, at index: Int, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            self.array.insert(element, at: index)
            DispatchQueue.main.async { completion?() }
        }
    }

    /// Removes and returns the first element of the collection.
    ///
    /// The collection must not be empty.
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameter completion: The handler with the removed element.
    func removeFirst(completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let element = self.array.removeFirst()
            DispatchQueue.main.async { completion?(element) }
        }
    }

    /// Removes the specified number of elements from the beginning of the collection.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - k: The number of elements to remove from the collection.
    ///   - completion: The block to execute when remove completed.
    func removeFirst(_ k: Int, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            defer { DispatchQueue.main.async { completion?() } }
            guard 0...self.array.count ~= k else { return }
            self.array.removeFirst(k)
        }
    }

    /// Removes and returns the last element of the collection.
    ///
    /// The collection must not be empty.
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameter completion: The handler with the removed element.
    func removeLast(completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let element = self.array.removeLast()
            DispatchQueue.main.async { completion?(element) }
        }
    }

    /// Removes the specified number of elements from the end of the collection.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - k: The number of elements to remove from the collection.
    ///   - completion: The block to execute when remove completed.
    func removeLast(_ k: Int, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            defer { DispatchQueue.main.async { completion?() } }
            guard 0...self.array.count ~= k else { return }
            self.array.removeLast(k)
        }
    }

    /// Removes and returns the element at the specified position.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - index: The position of the element to remove.
    ///   - completion: The handler with the removed element.
    func remove(at index: Int, completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let element = self.array.remove(at: index)
            DispatchQueue.main.async { completion?(element) }
        }
    }
    
    /// Removes and returns the elements that meet the criteria.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    ///   - completion: The handler with the removed elements.
    func remove(where predicate: @escaping (Element) -> Bool, completion: (([Element]) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            var elements = [Element]()
            
            while let index = self.array.firstIndex(where: predicate) {
                elements.append(self.array.remove(at: index))
            }
            
            DispatchQueue.main.async { completion?(elements) }
        }
    }

    /// Removes all elements from the array.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameter completion: The handler with the removed elements.
    func removeAll(completion: (([Element]) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()
            DispatchQueue.main.async { completion?(elements) }
        }
    }
    
    /// Accesses the element at the specified position if it exists.
    ///
    /// - Parameter index: The position of the element to access.
    /// - Returns: optional element if it exists.
    subscript(index: Int) -> Element? {
        get {
            var result: Element?
            queue.sync { result = self.array[safe: index] }
            return result
        }

        set {
            guard let newValue = newValue else { return }
            
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
    }
}

// MARK: - Equatable

public extension SynchronizedArray where Element: Equatable {

    /// Returns a Boolean value indicating whether the sequence contains the given element.
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: true if the element was found in the sequence; otherwise, false.
    func contains(_ element: Element) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(element) }
        return result
    }
    
    /// Removes the specified element.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameter element: An element to search for in the collection.
    func remove(_ element: Element, completion: (() -> Void)? = nil) {
        queue.async(flags: .barrier) {
            self.array.remove(element)
            DispatchQueue.main.async { completion?() }
        }
    }
    
    /// Removes the specified element.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - left: The collection to remove from.
    ///   - right: An element to search for in the collection.
    static func -= (left: inout SynchronizedArray, right: Element) {
        left.remove(right)
    }

    /// Adds a new element at the end of the array.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The element to append to the array.
    static func += (left: inout SynchronizedArray, right: Element) {
        left.append(right)
    }

    /// Adds new elements at the end of the array.
    ///
    /// The task is performed asynchronously due to thread-locking management.
    ///
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The elements to append to the array.
    static func += (left: inout SynchronizedArray, right: [Element]) {
        left.append(right)
    }
}
