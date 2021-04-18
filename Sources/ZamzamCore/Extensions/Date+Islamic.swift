//
//  Date+Islamic.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2020-03-26.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Foundation.NSCalendar
import Foundation.NSDate
import Foundation.NSDateFormatter

public extension Date {
    /// Determines if the date if Friday / Jumuah.
    var isJumuah: Bool { isJumuah(for: .current) }

    /// Determines if the date if Friday / Jumuah.
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isJumuah(for calendar: Calendar) -> Bool {
        calendar.dateComponents([.weekday], from: self).weekday == 6
    }

    /// Determines if the date falls within Ramadan.
    ///
    /// - Parameters:
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: True if the date is within Ramadan; false otherwise.
    func isRamadan(
        offSet: Int = 0,
        timeZone: TimeZone? = nil
    ) -> Bool {
        hijri(offSet: offSet, timeZone: timeZone, calendar: Self.islamicCalendar).month == 9
    }
}

public extension Date {
    // Cache Islamic calendar for reuse
    // https://www.staff.science.uu.nl/~gent0113/islam/ummalqura.htm
    // http://tabsir.net/?p=621#more-621
    static let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)

    /// Returns a string representation of a given date formatted to hijri date.
    ///
    /// - Parameters:
    ///   - components: The components of the date to format.
    ///   - format: The date format string used by the receiver.
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: A string representation of a given date formatted to hijri date.
    func hijriString(
        components: Set<Calendar.Component> = Calendar.Component.full,
        format: String? = nil,
        offSet: Int = 0,
        timeZone: TimeZone? = nil,
        calendar: Calendar = Self.islamicCalendar
    ) -> String {
        var calendar = calendar

        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }

        let formatter = DateFormatter().apply {
            $0.calendar = calendar
            $0.timeZone = calendar.timeZone

            if let f = format {
                $0.dateFormat = f
            } else {
                $0.dateStyle = .long
            }
        }

        let date = calendar.date(
            from: hijri(
                components: components,
                offSet: offSet,
                timeZone: timeZone,
                calendar: calendar
            )
        ) ?? self

        return formatter.string(from: date)
    }

    /// Returns the date components of the hijri date.
    ///
    /// - Parameters:
    ///   - components: The components of the date to format.
    ///   - offSet: The number of days to offset the hijri date.
    ///   - timeZone: The time zone for the receiver.
    ///   - calendar: The calendar of the receiver.
    /// - Returns: The date components of the hijri date.
    func hijri(
        components: Set<Calendar.Component> = Calendar.Component.full,
        offSet: Int = 0,
        timeZone: TimeZone? = nil,
        calendar: Calendar = Self.islamicCalendar
    ) -> DateComponents {
        var calendar = calendar

        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }

        let date = self + .days(offSet, calendar)
        return calendar.dateComponents(components, from: date)
    }
}
