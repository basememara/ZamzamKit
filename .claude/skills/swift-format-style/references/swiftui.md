# SwiftUI integration

The `Text` view accepts a `format:` parameter directly. Never use string interpolation with `.formatted()` inside `Text`.

## Core rule

```swift
// WRONG
Text("\(value.formatted(.number.precision(.fractionLength(2))))")
Text("\(date.formatted(.dateTime.hour().minute()))")

// CORRECT
Text(value, format: .number.precision(.fractionLength(2)))
Text(date, format: .dateTime.hour().minute())
```

## Examples

```swift
struct ContentView: View {
    let date = Date.now
    let price: Decimal = 9.99
    let progress = 0.75

    var body: some View {
        VStack {
            // Dates
            Text(date, format: Date.FormatStyle(date: .complete, time: .complete))
            Text(date, format: .dateTime.hour())
            Text(date, format: .dateTime.year().month().day())

            // Numbers
            Text(price, format: .currency(code: "USD"))
            Text(progress, format: .percent)

            // Duration
            Text(Duration.seconds(125), format: .time(pattern: .minuteSecond))
        }
    }
}
```

## Stopwatch and Timer (Xcode 16+)

SwiftUI-only format styles that output live-updating `AttributedString` values. These are not part of Foundation - they exist only in SwiftUI.

### Stopwatch

Displays elapsed time from a start date, counting up:

```swift
struct Stopwatch: View {
    @State var startDate: Date?
    @State var isRunning = false

    var body: some View {
        // Use TimeDataSource for live updates, static Date for paused state
        if isRunning {
            Text(TimeDataSource<Date>.currentDate, format: .stopwatch(startingAt: startDate ?? .now))
        } else {
            Text(Date.now, format: .stopwatch(startingAt: startDate ?? .now))
        }
        Button("Start") {
            startDate = .now
            isRunning = true
        }
    }
}
```

### Timer (countdown)

Displays remaining time within a date range, counting down:

```swift
struct CountdownTimer: View {
    @State var isRunning = false
    @State var timerRange: Range<Date>?

    var body: some View {
        if isRunning {
            Text(TimeDataSource<Date>.currentDate, format: .timer(countingDownIn: timerRange ?? .now ..< .now))
        } else {
            Text(.now, format: .timer(countingDownIn: timerRange ?? .now ..< .now))
        }
        Button("Start 60s") {
            let now = Date.now
            timerRange = now ..< Calendar.current.date(byAdding: .second, value: 60, to: now)!
            isRunning = true
        }
    }
}
```

### Key points

- Use `TimeDataSource<Date>.currentDate` instead of `TimelineView` for live updates
- Both output `AttributedString` by default - only `Text` views can display them
- Stopwatch accepts a single start `Date`; timer accepts a `Range<Date>`
- Timer shows `0:00` at or below lower bound, and the full offset at or above upper bound
- Always use `Calendar` APIs for date calculations (not manual `TimeInterval` arithmetic)

---

## AttributedString output for styled formatting

Many format styles support `.attributed` to get an `AttributedString` with individually styleable runs:

```swift
struct ContentView: View {
    var percentAttributed: AttributedString {
        var result = 0.8890.formatted(.percent.attributed)
        result.swiftUI.font = .title
        result.runs.forEach { run in
            if let numberRun = run.numberPart {
                switch numberRun {
                case .integer:
                    result[run.range].foregroundColor = .orange
                case .fraction:
                    result[run.range].foregroundColor = .blue
                }
            }
            if let symbolRun = run.numberSymbol {
                switch symbolRun {
                case .percent:
                    result[run.range].foregroundColor = .green
                case .decimalSeparator:
                    result[run.range].foregroundColor = .red
                default:
                    break
                }
            }
        }
        return result
    }

    var body: some View {
        Text(percentAttributed)
    }
}
```

Works with: `.number.attributed`, `.percent.attributed`, `.currency(code:).attributed`, `.dateTime.attributed`, `.measurement(width:).attributed`, `.byteCount(style:).attributed`

## Why this matters

- `Text(_:format:)` applies formatting at render time, respecting the view's environment locale
- String interpolation with `.formatted()` captures the formatted string eagerly, missing locale changes
- The `format:` parameter enables automatic updating when locale or calendar settings change
