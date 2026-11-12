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
    ///
    /// - Parameter calendar: Calendar used for calculation.
    /// - Returns: Returns true if date passes the criteria.
    func isJumuah(using calendar: Calendar) -> Bool {
        calendar.dateComponents([.weekday], from: self).weekday == 6
    }

    /// Determines if the date falls within Ramadan.
    ///
    /// - Parameters:
    ///   - offset: The number of days to offset the hijri date.
    ///   - timeZone: The time zone the date is read in.
    /// - Returns: True if the date is within Ramadan; false otherwise.
    func isRamadan(offset: Int = 0, timeZone: TimeZone) -> Bool {
        hijri(offset: offset, timeZone: timeZone).month == 9
    }

    /// Determines if the date falls within Eid ul-Fitr or Eid al-Adha.
    ///
    /// - Parameters:
    ///   - offset: The number of days to offset the hijri date.
    ///   - timeZone: The time zone the date is read in.
    /// - Returns: True if the date is within Eid; false otherwise.
    func isEid(offset: Int = 0, timeZone: TimeZone) -> Bool {
        let dateComponents = hijri(offset: offset, timeZone: timeZone)
        return (dateComponents.month == 10 && [1, 2, 3].contains(dateComponents.day)) // Eid ul-Fitr
            || (dateComponents.month == 12 && [10, 11, 12, 13].contains(dateComponents.day)) // Eid al-Adha
    }
}

public extension Date {
    /// Returns a string representation of a given date formatted to hijri date.
    ///
    /// - Parameters:
    ///   - template: The date format template used by the receiver.
    ///   - offset: The number of days to offset the hijri date.
    ///   - timeZone: The time zone the date is read in.
    ///   - locale: The locale the date is written for. Default is the device's.
    /// - Returns: A string representation of a given date formatted to hijri date.
    func hijriString(
        template: String = "yyyyMMMMd",
        offset: Int = 0,
        timeZone: TimeZone,
        locale: Locale = .current
    ) -> String {
        let calendar = Calendar.hijri(in: timeZone)

        let formatter = DateFormatter().apply {
            $0.locale = locale
            $0.calendar = calendar
            $0.timeZone = timeZone

            if let dateFormat = DateFormatter.dateFormat(
                fromTemplate: template,
                options: 0,
                locale: locale
            ) {
                $0.dateFormat = dateFormat
            } else {
                $0.dateStyle = .long
            }
        }

        return formatter.string(from: self + .days(offset, calendar))
    }

    /// Returns the date components of the hijri date.
    ///
    /// - Parameters:
    ///   - components: The components of the date to format.
    ///   - offset: The number of days to offset the hijri date.
    ///   - timeZone: The time zone the date is read in.
    /// - Returns: The date components of the hijri date.
    func hijri(
        components: Set<Calendar.Component> = Calendar.Component.full,
        offset: Int = 0,
        timeZone: TimeZone
    ) -> DateComponents {
        let calendar = Calendar.hijri(in: timeZone)
        return calendar.dateComponents(components, from: self + .days(offset, calendar))
    }
}

private extension Calendar {
    // https://www.staff.science.uu.nl/~gent0113/islam/ummalqura.htm
    // http://tabsir.net/?p=621#more-621
    static func hijri(in timeZone: TimeZone) -> Calendar {
        Calendar(identifier: .islamicUmmAlQura, timeZone: timeZone)
    }
}
