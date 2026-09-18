# Date styles

Covers all date formatting: compositing, date/time presets, ISO 8601, relative, verbatim, HTTP, intervals, and components.

## Date.FormatStyle compositing

Mix and match date components like lego blocks. Order of symbols does not affect output - the locale controls display order.

```swift
let twosday = Calendar(identifier: .gregorian).date(from: DateComponents(
    year: 2022, month: 2, day: 22, hour: 2, minute: 22, second: 22
))!

twosday.formatted(.dateTime.day())     // "22"
twosday.formatted(.dateTime.month())   // "Feb"
twosday.formatted(.dateTime.year())    // "2022"
twosday.formatted(.dateTime.hour())    // "2 AM"
twosday.formatted(.dateTime.minute())  // "22"
twosday.formatted(.dateTime.second())  // "22"
twosday.formatted(.dateTime.weekday()) // "Tue"
twosday.formatted(.dateTime.era())     // "AD"
twosday.formatted(.dateTime.quarter()) // "Q1"

// Chained - locale controls order, not call order
twosday.formatted(.dateTime.year().month().day().hour().minute().second())
// "Feb 22, 2022, 2:22:22 AM"
```

### Component options

**Day:**
```swift
.day(.twoDigits)           // "22"
.day(.defaultDigits)       // "22"
.day(.ordinalOfDayInMonth) // "4"
```

**Month:**
```swift
.month(.defaultDigits) // "2"
.month(.twoDigits)     // "02"
.month(.wide)          // "February"
.month(.abbreviated)   // "Feb"
.month(.narrow)        // "F"
```

**Year:**
```swift
.year(.twoDigits)      // "22"
.year(.defaultDigits)  // "2022"
.year(.padded(10))     // "0000002022"
```

**Hour:**
```swift
.hour(.defaultDigits(amPM: .wide))        // "2 AM"
.hour(.defaultDigits(amPM: .narrow))      // "2 a"
.hour(.defaultDigits(amPM: .abbreviated)) // "2 AM"
.hour(.defaultDigits(amPM: .omitted))     // "02"
.hour(.twoDigits(amPM: .wide))           // "02 AM"
```

**Weekday:**
```swift
.weekday(.abbreviated) // "Tue"
.weekday(.wide)        // "Tuesday"
.weekday(.narrow)      // "T"
.weekday(.short)       // "Tu"
```

**Time zone:**
```swift
.timeZone(.specificName(.short))  // "MST"
.timeZone(.specificName(.long))   // "Mountain Standard Time"
.timeZone(.genericName(.short))   // "MT"
.timeZone(.identifier(.long))     // "America/Edmonton"
.timeZone(.iso8601(.long))        // "-07:00"
.timeZone(.localizedGMT(.short))  // "GMT-7"
.timeZone(.exemplarLocation)      // "Edmonton"
```

---

## Date and time presets

Quick formatting with preset styles:

**DateStyle:** `.omitted`, `.numeric`, `.abbreviated`, `.long`, `.complete`
**TimeStyle:** `.omitted`, `.shortened`, `.standard`, `.complete`

```swift
twosday.formatted(date: .abbreviated, time: .omitted)  // "Feb 22, 2022"
twosday.formatted(date: .complete, time: .omitted)     // "Tuesday, February 22, 2022"
twosday.formatted(date: .long, time: .omitted)         // "February 22, 2022"
twosday.formatted(date: .numeric, time: .omitted)      // "2/22/2022"

twosday.formatted(date: .omitted, time: .complete)     // "2:22:22 AM MST"
twosday.formatted(date: .omitted, time: .shortened)    // "2:22 AM"
twosday.formatted(date: .omitted, time: .standard)     // "2:22:22 AM"

twosday.formatted(date: .abbreviated, time: .shortened) // "Feb 22, 2022, 2:22 AM"
```

Custom with locale and calendar:

```swift
let frenchHebrew = Date.FormatStyle(
    date: .complete,
    time: .complete,
    locale: Locale(identifier: "fr_FR"),
    calendar: Calendar(identifier: .hebrew),
    timeZone: TimeZone(secondsFromGMT: 0)!,
    capitalizationContext: .standalone
)
twosday.formatted(frenchHebrew) // "Mardi 22 fevrier 2022 ap. J.-C. 9:22:22 UTC"
```

---

## ISO 8601

```swift
twosday.formatted(.iso8601) // "2022-02-22T09:22:22Z"
```

Custom configuration:

```swift
let isoFormat = Date.ISO8601FormatStyle(
    dateSeparator: .dash,
    dateTimeSeparator: .standard,
    timeSeparator: .colon,
    timeZoneSeparator: .colon,
    includingFractionalSeconds: true,
    timeZone: TimeZone(secondsFromGMT: 0)!
)
isoFormat.format(twosday) // "2022-02-22T09:22:22.000Z"
```

Parsing:

```swift
try? Date.ISO8601FormatStyle(timeZone: TimeZone(secondsFromGMT: 0)!)
    .year().day().month()
    .dateSeparator(.dash).dateTimeSeparator(.standard).timeSeparator(.colon)
    .time(includingFractionalSeconds: true)
    .parse("2022-02-22T09:22:22.000") // Feb 22, 2022, 2:22:22 AM
```

---

## Relative date

Automatically selects the largest relevant time unit:

**Presentation:** `.numeric` ("1 day ago"), `.named` ("yesterday")
**Unit style:** `.abbreviated`, `.narrow`, `.spellOut`, `.wide`

```swift
let thePast = Calendar.current.date(byAdding: .day, value: -14, to: Date())!

thePast.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated)) // "2 wk. ago"
thePast.formatted(.relative(presentation: .numeric, unitsStyle: .spellOut))    // "two weeks ago"
thePast.formatted(.relative(presentation: .named, unitsStyle: .wide))          // "2 weeks ago"
```

Locale:

```swift
thePast.formatted(.relative(presentation: .named, unitsStyle: .spellOut).locale(Locale(identifier: "fr_FR")))
// "il y a deux semaines"
```

---

## Anchored relative (Xcode 16+)

Like relative, but detached from the system clock - fixed anchor date for deterministic output:

```swift
let anchorDate = Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!
let style = Date.AnchoredRelativeFormatStyle(anchor: anchorDate)
style.format(Date.now) // "3 days ago"
```

Restrict displayed units:

```swift
let anchor = Calendar.current.date(byAdding: .hour, value: -49, to: Date.now)!
Date.AnchoredRelativeFormatStyle(anchor: anchor).format(Date.now)                        // "2 days ago"
Date.AnchoredRelativeFormatStyle(anchor: anchor, allowedFields: [.hour]).format(Date.now) // "49 hours ago"
```

---

## Verbatim

For fixed, structured format strings (replacement for `dateFormat`). Uses type-safe string interpolation instead of cryptic Unicode patterns like `"yyyy-MMM-dd"`.

```swift
twosday.formatted(
    .verbatim(
        "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .oneBased)):\(minute: .twoDigits):\(second: .twoDigits)",
        locale: .current,
        timeZone: .current,
        calendar: .current
    )
)
// "2022-02-22 22:22:22"
```

With literal text mixed in:

```swift
twosday.formatted(
    .verbatim(
        "It's Twosday! \(year: .defaultDigits)-\(month: .abbreviated)(\(month: .defaultDigits))-\(day: .defaultDigits)",
        locale: Locale(identifier: "en_US"),
        timeZone: .current,
        calendar: .current
    )
)
// "It's Twosday! 2022-Feb(2)-22"
```

### Verbatim pitfalls

**Always specify locale explicitly.** Omitting locale defaults to `nil`, producing broken output:

```swift
// WRONG - nil locale gives garbled output
Date.VerbatimFormatStyle(
    format: "\(year: .defaultDigits)-\(month: .abbreviated)-\(day: .twoDigits)",
    timeZone: .current,
    calendar: .current
).format(twosday)
// "2022-M02-22" <- broken, not "2022-Feb-22"

// CORRECT - always provide locale
Date.VerbatimFormatStyle(
    format: "\(year: .defaultDigits)-\(month: .abbreviated)-\(day: .twoDigits)",
    locale: Locale(identifier: "en_US"),
    timeZone: .current,
    calendar: .current
).format(twosday)
// "2022-Feb-22"
```

**`.autoupdatingCurrent` locale overrides calendar parameter:**

```swift
// Locale .autoupdatingCurrent ignores calendar
Date.VerbatimFormatStyle(
    format: "\(year: .defaultDigits)-\(month: .abbreviated)-\(day: .twoDigits)",
    locale: .autoupdatingCurrent,
    timeZone: .autoupdatingCurrent,
    calendar: Calendar(identifier: .buddhist)
).format(twosday) // "2022-Feb-22" <- ignores Buddhist calendar

// Explicit locale respects calendar
Date.VerbatimFormatStyle(
    format: "\(year: .defaultDigits)-\(month: .abbreviated)-\(day: .twoDigits)",
    locale: Locale(identifier: "en_US"),
    timeZone: .autoupdatingCurrent,
    calendar: Calendar(identifier: .buddhist)
).format(twosday) // "2565-Feb-22" <- correct Buddhist year
```

---

## HTTP

Fixed RFC 9110-compliant format for HTTP headers. No customization.

```swift
twosday.formatted(.http) // "Tue, 22 Feb 2022 09:22:22 GMT"

try? Date.HTTPFormatStyle().parse("Tue, 22 Feb 2022 09:22:22 GMT") // Feb 22, 2022
```

---

## Interval (date range)

Shows earliest and latest dates:

```swift
let range = date1..<date2

range.formatted(.interval)                    // "12/31/69, 5:00 PM - 12/31/00, 5:47 PM"
range.formatted(.interval.year())             // "1969 - 2000"
range.formatted(.interval.month(.wide))       // "December 1969 - December 2000"
range.formatted(.interval.hour())             // "12/31/1969, 5 PM - 12/31/2000, 5 PM"
```

---

## Components (date range)

Shows distance between dates in plain language:

**Styles:** `.wide`, `.abbreviated`, `.condensedAbbreviated`, `.narrow`, `.spellOut`

```swift
let range = date1..<date2

range.formatted(.components(style: .abbreviated, fields: [.year, .month, .week]))
// "21 yrs, 1 mth, 3 wks"

range.formatted(.components(style: .condensedAbbreviated, fields: [.day, .month, .year]))
// "31y"

range.formatted(.components(style: .spellOut, fields: [.day]))
// "eleven thousand three hundred twenty-three days"

range.formatted(.components(style: .wide, fields: [.year, .month, .week, .hour, .second])
    .locale(Locale(identifier: "fr_FR")))
// "21 ans, 1 mois, 3 semaines, 9 heures et 1 342 secondes"
```

---

## Parsing dates

```swift
try? Date.FormatStyle()
    .day().month().year().hour().minute().second()
    .parse("Feb 22, 2022, 2:22:22 AM")

try? Date(
    "Feb 22, 2022, 2:22:22 AM",
    strategy: Date.FormatStyle().day().month().year().hour().minute().second().parseStrategy
)
```
