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
    /// Returns whether the date is a Friday on the calendar, in its time zone.
    func isJumuah(using calendar: Calendar) -> Bool {
        calendar.dateComponents([.weekday], from: self).weekday == 6
    }

    /// Returns whether the date falls in Ramadan on the Umm al-Qura calendar.
    ///
    /// - Parameters:
    ///   - offset: Days added to the date before it is read, for a community whose month starts on another day.
    ///   - timeZone: The time zone the date is read in.
    func isRamadan(offset: Int = 0, timeZone: TimeZone) -> Bool {
        hijri(offset: offset, timeZone: timeZone).month == 9
    }

    /// Returns whether the date is a day of Eid on the Umm al-Qura calendar: 1 to 3 Shawwal, or 10 to 13 Dhul-Hijjah.
    ///
    /// - Parameters:
    ///   - offset: Days added to the date before it is read.
    ///   - timeZone: The time zone the date is read in.
    func isEid(offset: Int = 0, timeZone: TimeZone) -> Bool {
        let dateComponents = hijri(offset: offset, timeZone: timeZone)
        return (dateComponents.month == 10 && [1, 2, 3].contains(dateComponents.day)) // Eid ul-Fitr
            || (dateComponents.month == 12 && [10, 11, 12, 13].contains(dateComponents.day)) // Eid al-Adha
    }
}

public extension Date {
    /// Returns the date written on the Umm al-Qura calendar, in the locale's format for the template.
    ///
    ///     // For June 26, 2017:
    ///     date.hijriString(timeZone: timeZone, locale: Locale(identifier: "en_US")) // "Shawwal 2, 1438"
    ///
    /// - Parameters:
    ///   - template: The fields to show, as a date format template. One the locale can't resolve gives the long date style.
    ///   - offset: Days added to the date before it is read.
    ///   - timeZone: The time zone the date is read in.
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

    /// Returns the date's components on the Umm al-Qura calendar.
    ///
    /// - Parameters:
    ///   - components: The components to read. The default is the year through the second.
    ///   - offset: Days added to the date before it is read.
    ///   - timeZone: The time zone the date is read in.
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
