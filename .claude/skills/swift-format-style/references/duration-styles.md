# Duration styles

Requires Xcode 14+ (iOS 16+). Two styles: `TimeFormatStyle` and `UnitsFormatStyle`.

## Time style

Formats duration using hours, minutes, and seconds with clock-like output.

```swift
Duration.seconds(1_000).formatted()                                      // "0:16:40"
Duration.seconds(1_000).formatted(.time(pattern: .hourMinute))           // "0:17"
Duration.seconds(1_000).formatted(.time(pattern: .hourMinuteSecond))     // "0:16:40"
Duration.seconds(1_000).formatted(.time(pattern: .minuteSecond))         // "16:40"
```

### Pattern methods with parameters

**hourMinute():** `padHourToLength`, `roundSeconds`

```swift
Duration.seconds(1_000).formatted(.time(pattern: .hourMinute(padHourToLength: 3, roundSeconds: .awayFromZero)))
// "000:17"

Duration.seconds(1_000).formatted(.time(pattern: .hourMinute(padHourToLength: 1, roundSeconds: .down)))
// "000:16"
```

**hourMinuteSecond() / minuteSecond():** `padHourToLength`/`padMinuteToLength`, `fractionalSecondsLength`, `roundFractionalSeconds`

```swift
Duration.seconds(1_000).formatted(
    .time(pattern: .hourMinuteSecond(padHourToLength: 3, fractionalSecondsLength: 3, roundFractionalSeconds: .awayFromZero))
) // "000:16:40.000"

Duration.seconds(1_000).formatted(
    .time(pattern: .minuteSecond(padMinuteToLength: 3, fractionalSecondsLength: 3, roundFractionalSeconds: .awayFromZero))
) // "016:40.000"
```

### Locale

```swift
Duration.seconds(1_000).formatted(.time(pattern: .hourMinute).locale(Locale(identifier: "fr_FR"))) // "0:17"
```

---

## Units style

Displays duration using named units.

```swift
Duration.seconds(100).formatted(.units()) // "1 min, 40 sec"
```

### Allowed units

`.nanoseconds`, `.microseconds`, `.milliseconds`, `.seconds`, `.minutes`, `.hours`, `.days`, `.weeks`

```swift
Duration.milliseconds(500).formatted(.units(allowed: [.nanoseconds]))   // "500,000,000 ns"
Duration.milliseconds(500).formatted(.units(allowed: [.microseconds]))  // "500,000 us"
Duration.milliseconds(500).formatted(.units(allowed: [.milliseconds]))  // "500 ms"
Duration.milliseconds(500).formatted(.units(allowed: [.seconds]))       // "0 sec"

Duration.seconds(1_000_000.00123).formatted(
    .units(allowed: [.nanoseconds, .milliseconds, .seconds, .minutes, .hours, .days, .weeks])
) // "1 wk, 4 days, 13 hr, 46 min, 40 sec, 1 ms, 230,000 ns"
```

### Width

| Value | Example |
|-------|---------|
| `.wide` | "1 minute, 40 seconds" |
| `.abbreviated` | "1 min, 40 sec" |
| `.condensedAbbreviated` | "1 min,40 sec" |
| `.narrow` | "1m 40s" |

```swift
Duration.seconds(100).formatted(.units(width: .wide))                 // "1 minute, 40 seconds"
Duration.seconds(100).formatted(.units(width: .abbreviated))          // "1 min, 40 sec"
Duration.seconds(100).formatted(.units(width: .condensedAbbreviated)) // "1 min,40 sec"
Duration.seconds(100).formatted(.units(width: .narrow))               // "1m 40s"
```

### maximumUnitCount

```swift
Duration.seconds(10000).formatted(.units(maximumUnitCount: 1)) // "3 hr"
Duration.seconds(10000).formatted(.units(maximumUnitCount: 2)) // "2 hr, 47 min"
Duration.seconds(10000).formatted(.units(maximumUnitCount: 3)) // "2 hr, 46 min, 40 sec"
```

### zeroValueUnits

```swift
Duration.seconds(100).formatted(.units(zeroValueUnits: .hide))             // "1 min, 40 sec"
Duration.seconds(100).formatted(.units(zeroValueUnits: .show(length: 1)))  // "0 hr, 1 min, 40 sec"
Duration.seconds(100).formatted(.units(zeroValueUnits: .show(length: 3)))  // "000 hr, 001 min, 040 sec"
```

### valueLength and valueLengthLimits

```swift
Duration.seconds(1_000).formatted(.units(valueLength: 1)) // "16 min, 40 sec"
Duration.seconds(1_000).formatted(.units(valueLength: 3)) // "016 min, 040 sec"

Duration.seconds(100).formatted(.units(valueLengthLimits: 2 ... 3)) // "01 min, 40 sec"
```

### fractionalPart

```swift
Duration.seconds(10.0_023).formatted(.units(fractionalPart: .hide))                         // "10 sec"
Duration.seconds(10.0_023).formatted(.units(fractionalPart: .hide(rounded: .up)))            // "11 sec"
Duration.seconds(10.0_023).formatted(.units(fractionalPart: .show(length: 5)))               // "10.00230 sec"
Duration.seconds(10.0_023).formatted(.units(fractionalPart: .show(length: 3, rounded: .up))) // "10.003 sec"
Duration.seconds(10.0_023).formatted(.units(fractionalPart: .show(length: 3, increment: 0.001))) // "10.002 sec"
```
