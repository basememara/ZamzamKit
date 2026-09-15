---
name: swift-format-style
description: Writes and reviews Swift FormatStyle code, replacing legacy Formatter subclasses and C-style String(format:) with modern .formatted() APIs. Use when formatting numbers, dates, durations, measurements, lists, names, byte counts, or URLs.
license: MIT
metadata:
  author: Anton Novoselov
  version: "1.0"
---

Write and review Swift code that formats values for display, ensuring modern FormatStyle APIs are used instead of legacy Formatter subclasses or C-style formatting.

Review process:

1. Check for legacy formatting patterns and replace with modern FormatStyle equivalents using `references/anti-patterns.md`.
1. Validate number, percent, and currency formatting using `references/numeric-styles.md`.
1. Validate date and time formatting using `references/date-styles.md`.
1. Validate duration formatting using `references/duration-styles.md`.
1. Validate measurement, list, person name, byte count, and URL formatting using `references/other-styles.md`.
1. Check SwiftUI Text views for proper FormatStyle integration using `references/swiftui.md`.

If doing partial work, load only the relevant reference files.


## Core Instructions

- Target iOS 15+ / macOS 12+ minimum for basic FormatStyle. Duration and URL styles require iOS 16+ / macOS 13+.
- **Never** use legacy `Formatter` subclasses (`DateFormatter`, `NumberFormatter`, `MeasurementFormatter`, `DateComponentsFormatter`, `DateIntervalFormatter`, `PersonNameComponentsFormatter`, `ByteCountFormatter`).
- **Never** use C-style `String(format:)` for number formatting. Always use `.formatted()` or `FormatStyle` directly.
- **Never** use `DispatchQueue` for formatting on background threads - FormatStyle types are value types and thread-safe.
- Prefer `.formatted()` instance method for simple cases, and explicit `FormatStyle` types for reusable or complex configurations.
- In SwiftUI, use `Text(_:format:)` instead of `Text("\(value.formatted())")`.
- Use `Decimal` instead of `Float`/`Double` for currency values.
- FormatStyle types are locale-aware by default. Only set locale explicitly when you need a specific locale different from the user's current locale.
- FormatStyle types conform to `Codable` and `Hashable`, making them safe to store and compare.


## Output Format

If the user asks for a review, organize findings by file. For each issue:

1. State the file and relevant line(s).
2. Name the anti-pattern being replaced.
3. Show a brief before/after code fix.

Skip files with no issues. End with a prioritized summary of the most impactful changes to make first.

If the user asks you to write or fix formatting code, make the changes directly instead of returning a findings report.

Example output:

### RecordingView.swift

**Line 42: Use Duration.formatted() instead of String(format:) for time display.**

```swift
// Before
let minutes = Int(duration) / 60
let seconds = Int(duration) % 60
return String(format: "%02d:%02d", minutes, seconds)

// After
Duration.seconds(duration).formatted(.time(pattern: .minuteSecond))
```

**Line 78: Use Text(_:format:) instead of string interpolation.**

```swift
// Before
Text("\(fileSize.formatted(.byteCount(style: .file)))")

// After
Text(fileSize, format: .byteCount(style: .file))
```

### Summary

1. **Legacy formatting (high):** C-style String(format:) on line 42 should use Duration.formatted().
2. **SwiftUI (medium):** Text interpolation on line 78 should use the format: parameter directly.

End of example.


## References

- `references/anti-patterns.md` - legacy patterns to replace: String(format:), DateFormatter, NumberFormatter, and other Formatter subclasses.
- `references/numeric-styles.md` - number, percent, and currency formatting with rounding, precision, sign, notation, scale, and grouping.
- `references/date-styles.md` - date/time compositing, ISO 8601, relative, verbatim, HTTP, interval, and components styles.
- `references/duration-styles.md` - Duration.TimeFormatStyle and Duration.UnitsFormatStyle with patterns, units, width, and fractional seconds.
- `references/other-styles.md` - measurement, list, person name, byte count, URL formatting, and custom FormatStyle creation.
- `references/swiftui.md` - SwiftUI Text integration and best practices.
