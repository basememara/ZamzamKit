# Anti-patterns: Legacy formatting to replace

LLMs frequently generate legacy formatting code from pre-iOS 15 training data. This guide covers the patterns you must catch and replace.

## C-style String(format:) for numbers

This is the single most common mistake. Never format numbers with `String(format:)`.

```swift
// WRONG - C-style formatting
String(format: "%.2f", value)
String(format: "%02d:%02d", minutes, seconds)
String(format: "%d%%", percentage)
String(format: "$%.2f", price)

// CORRECT - FormatStyle
value.formatted(.number.precision(.fractionLength(2)))
Duration.seconds(totalSeconds).formatted(.time(pattern: .minuteSecond))
percentage.formatted(.percent)
price.formatted(.currency(code: "USD"))
```

## Legacy Formatter subclasses

Every `Formatter` subclass has a modern replacement:

| Legacy | Modern replacement |
|--------|-------------------|
| `NumberFormatter` | `.formatted(.number)` / `FloatingPointFormatStyle` / `IntegerFormatStyle` |
| `DateFormatter` | `.formatted(.dateTime)` / `Date.FormatStyle` |
| `DateComponentsFormatter` | `Duration.formatted(.units())` / `Duration.formatted(.time(...))` |
| `DateIntervalFormatter` | `.formatted(.interval)` / `Date.IntervalFormatStyle` |
| `MeasurementFormatter` | `.formatted(.measurement(...))` |
| `PersonNameComponentsFormatter` | `.formatted(.name(style:))` |
| `ByteCountFormatter` | `.formatted(.byteCount(style:))` |
| `RelativeDateTimeFormatter` | `.formatted(.relative(...))` |

## Common duration formatting mistakes

Agents frequently build manual duration formatting instead of using the built-in styles:

```swift
// WRONG - manual calculation
let minutes = Int(seconds) / 60
let secs = Int(seconds) % 60
return String(format: "%02d:%02d", minutes, secs)

// CORRECT - Duration.TimeFormatStyle
Duration.seconds(seconds).formatted(.time(pattern: .minuteSecond))
// Output: "16:40"

// WRONG - manual hours:minutes:seconds
let h = Int(seconds) / 3600
let m = (Int(seconds) % 3600) / 60
let s = Int(seconds) % 60
return String(format: "%d:%02d:%02d", h, m, s)

// CORRECT
Duration.seconds(seconds).formatted(.time(pattern: .hourMinuteSecond))
// Output: "0:16:40"
```

## Common date formatting mistakes

```swift
// WRONG - DateFormatter
let formatter = DateFormatter()
formatter.dateStyle = .medium
formatter.timeStyle = .short
return formatter.string(from: date)

// CORRECT
date.formatted(date: .abbreviated, time: .shortened)

// WRONG - custom date format string
let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd"
return formatter.string(from: date)

// CORRECT - verbatim for fixed formats
date.formatted(
    .verbatim(
        "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
        locale: .current,
        timeZone: .current,
        calendar: .current
    )
)

// CORRECT - ISO 8601 if that's the intent
date.formatted(.iso8601)
```

## SwiftUI-specific anti-patterns

```swift
// WRONG - formatting in string interpolation
Text("\(price, specifier: "%.2f")")
Text("\(Date(), formatter: dateFormatter)")
Text(String(format: "%.1f%%", percentage * 100))

// CORRECT - use format: parameter
Text(price, format: .currency(code: "USD"))
Text(Date(), format: .dateTime.hour().minute())
Text(percentage, format: .percent)
```

## Verbatim locale pitfall

When using `.verbatim()`, always specify locale explicitly. Omitting it defaults to `nil` and produces broken output:

```swift
// WRONG - nil locale
date.formatted(.verbatim(
    "\(year: .defaultDigits)-\(month: .abbreviated)-\(day: .twoDigits)",
    timeZone: .current, calendar: .current
))
// "2022-M02-22" <- broken

// CORRECT
date.formatted(.verbatim(
    "\(year: .defaultDigits)-\(month: .abbreviated)-\(day: .twoDigits)",
    locale: Locale(identifier: "en_US"), timeZone: .current, calendar: .current
))
// "2022-Feb-22"
```

## Unnecessary manual locale handling

FormatStyle respects the user's locale automatically. Only set locale explicitly when you need a *specific* locale:

```swift
// UNNECESSARY
let formatter = NumberFormatter()
formatter.locale = Locale.current  // redundant
formatter.numberStyle = .decimal
return formatter.string(from: NSNumber(value: number))!

// CORRECT - locale is automatic
number.formatted(.number)

// ONLY set locale when you need a specific one
number.formatted(.number.locale(Locale(identifier: "fr_FR")))
```
