//
//  Deprecated.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-11-01.
//  Copyright © 2018 Zamzam. All rights reserved.
//

public extension String {
    
    @available(*, unavailable, renamed: "String.replacing(regex:)")
    func replace(regex: String, with replacement: String, caseSensitive: Bool = false) -> String {
        return replacing(regex: regex, with: replacement, caseSensitive: caseSensitive)
    }
    
    @available(*, unavailable, renamed: "String.match(regex:)")
    func match(_ pattern: String, caseSensitive: Bool = false) -> Bool {
        return match(regex: pattern)
    }
    
    @available(*, unavailable, renamed: "separated")
    func separate(every: Int, with separator: String) -> String {
        return separated(every: every, with: separator)
    }
}

public extension Date {
    
    @available(*, unavailable, renamed: "Date.isBeyond(_:bySeconds:)")
    func hasElapsed(seconds: Int, from date: Date = Date()) -> Bool {
        return date.timeIntervalSince(self).seconds > seconds
    }
    
    @available(*, unavailable, message: "Use Date() + .years(5)")
    func increment(years: Int, calendar: Calendar = .current) -> Date {
        guard years != 0 else { return self }
        return calendar.date(
            byAdding: .year,
            value: years,
            to: self
        )!
    }
    
    @available(*, unavailable, message: "Use Date() + .months(5)")
    func increment(months: Int, calendar: Calendar = .current) -> Date {
        guard months != 0 else { return self }
        return calendar.date(
            byAdding: .month,
            value: months,
            to: self
        )!
    }
    
    @available(*, unavailable, message: "Use Date() + .days(5)")
    func increment(days: Int, calendar: Calendar = .current) -> Date {
        guard days != 0 else { return self }
        return calendar.date(
            byAdding: .day,
            value: days,
            to: self
        )!
    }
    
    @available(*, unavailable, message: "Use Date() + .minutes(5)")
    func increment(minutes: Int, calendar: Calendar = .current) -> Date {
        guard minutes != 0 else { return self }
        return calendar.date(
            byAdding: .minute,
            value: minutes,
            to: self
        )!
    }
    
    @available(*, unavailable)
    func incrementDayIfPast(calendar: Calendar = .current) -> Date {
        return isPast ? self + .days(1, calendar) : self
    }
}

public extension Calendar {
    
    @available(*, unavailable, renamed: "Calendar.posix")
    static let gregorianUTC: Calendar = .posix
}

@available(*, unavailable, renamed: "UserDefaults.Keys")
open class DefaultsKeys {
    fileprivate init() {}
}

@available(*, unavailable, renamed: "UserDefaults.Key")
open class DefaultsKey<ValueType>: UserDefaults.Keys {
    public let name: String
    
    public init(_ key: String) {
        self.name = key
        super.init()
    }
}

public extension Array {
    
    @available(*, unavailable, message: "Use collection[safe: index]")
    func get(_ index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
}

public extension ArraySlice {
    
    @available(*, unavailable, message: "Use collection[safe: index]")
    func get(_ index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[safe: index]
    }
}

#if os(iOS) || os(watchOS)
@available(*, unavailable, renamed: "LocationWorker")
public class LocationsWorker: LocationWorker {
    
}

@available(*, unavailable, renamed: "LocationWorkerType")
public protocol LocationsWorkerType: LocationWorkerType {
    
}
#endif
