# Other styles

Covers measurement, list, person name, byte count, URL, and custom FormatStyle.

## Measurement style

Formats any `Measurement<UnitType>` with locale-aware unit conversion.

**Important:** Measurement output is non-deterministic across devices. The default `.general` usage converts to the device locale's preferred unit, so the same code produces different output on a US vs Swedish device. Always test with explicit locales.

```swift
Measurement(value: 100, unit: UnitSpeed.kilometersPerHour).formatted() // "62 mph" (US locale)
Measurement(value: 200, unit: UnitLength.kilometers).formatted()       // "124 mi" (US locale)
Measurement(value: 70, unit: UnitLength.feet).formatted()              // "70 ft"
Measurement(value: 98.5, unit: UnitTemperature.fahrenheit).formatted() // "98degF"
```

### Width

```swift
let speed = Measurement(value: 100, unit: UnitSpeed.kilometersPerHour)

speed.formatted(.measurement(width: .wide))        // "62 miles per hour"
speed.formatted(.measurement(width: .abbreviated))  // "62 mph"
speed.formatted(.measurement(width: .narrow))       // "62mph"
```

### Usage

`.general` - locale-appropriate unit, `.asProvided` - keeps original unit:

```swift
let myHeight = Measurement(value: 190, unit: UnitLength.centimeters)

myHeight.formatted(.measurement(width: .abbreviated, usage: .general).locale(Locale(identifier: "en-US")))
// "6.2 ft"
myHeight.formatted(.measurement(width: .abbreviated, usage: .asProvided).locale(Locale(identifier: "en-US")))
// "190 cm"
myHeight.formatted(.measurement(width: .abbreviated, usage: .personHeight).locale(Locale(identifier: "en-US")))
// "6 ft, 2.8 in"
```

### Unit-specific usage options

**UnitLength:** `.person`, `.personHeight`, `.road`, `.focalLength`, `.rainfall`, `.snowfall`
**UnitMass:** `.personWeight`
**UnitTemperature:** `.person`, `.weather`
**UnitEnergy:** `.food`, `.workout`
**UnitVolume:** `.liquid`

### numberFormatStyle

Control numeric portion formatting:

```swift
myHeight.formatted(
    .measurement(width: .abbreviated, usage: .personHeight, numberFormatStyle: .number.precision(.fractionLength(0)))
    .locale(Locale(identifier: "en-US"))
) // "6 ft, 3 in"
```

### UnitTemperature: hidesScaleName

Only available for `UnitTemperature` - omits the scale name from output:

```swift
let temp = Measurement(value: 25.0, unit: UnitTemperature.celsius)

temp.formatted(.measurement(width: .wide, usage: .asProvided))                          // "25 degrees Celsius"
temp.formatted(.measurement(width: .wide, usage: .asProvided, hidesScaleName: true))    // "25 degrees"
temp.formatted(.measurement(width: .abbreviated, usage: .asProvided, hidesScaleName: true)) // "25deg"
```

### Custom units

You can create custom units and use them with Measurement formatting:

```swift
// One-off custom unit
let smoots = UnitLength(symbol: "smoot", converter: UnitConverterLinear(coefficient: 1.70180))
let bridgeLength = Measurement(value: 364.4, unit: smoots)
bridgeLength.formatted(.measurement(width: .abbreviated, usage: .asProvided)) // "364.4 smoot"

// Extending an existing Dimension
extension UnitSpeed {
    static let furlongPerFortnight = UnitSpeed(
        symbol: "fur/ftn",
        converter: UnitConverterLinear(coefficient: 201.168 / 1209600.0)
    )
}
```

**Note:** Custom units only display correctly with `.asProvided` usage since the system doesn't know how to localize them.

---

## List style

Converts arrays into localized text lists.

```swift
["a", "b", "c", "d"].formatted()                                   // "a, b, c, and d"
["a", "b", "c", "d"].formatted(.list(type: .and, width: .standard)) // "a, b, c, and d"
["a", "b", "c", "d"].formatted(.list(type: .and, width: .short))    // "a, b, c, & d"
["a", "b", "c", "d"].formatted(.list(type: .and, width: .narrow))   // "a, b, c, d"
["a", "b", "c", "d"].formatted(.list(type: .or, width: .standard))  // "a, b, c, or d"
```

Locale:

```swift
["a", "b", "c", "d"].formatted(.list(type: .and).locale(Locale(identifier: "fr_FR")))
// "a, b, c, et d"
```

Custom item formatting:

```swift
let dates = [date1, date2]
dates.formatted(.list(memberStyle: Date.FormatStyle().year(), type: .and))
// "2001 and 1970"
```

---

## Person name style

```swift
let guest = PersonNameComponents(
    namePrefix: "Dr",
    givenName: "Elizabeth",
    middleName: "Jillian",
    familyName: "Smith",
    nameSuffix: "Esq.",
    nickname: "Liza"
)

guest.formatted()                           // "Elizabeth Smith"
guest.formatted(.name(style: .abbreviated)) // "ES"
guest.formatted(.name(style: .short))       // "Liza"
guest.formatted(.name(style: .medium))      // "Elizabeth Smith"
guest.formatted(.name(style: .long))        // "Dr Elizabeth Jillian Smith Esq."
```

Locale-aware ordering:

```swift
guest.formatted(.name(style: .medium).locale(Locale(identifier: "zh_CN")))
// "Smith Elizabeth"
```

Parsing:

```swift
try? PersonNameComponents.FormatStyle().parseStrategy.parse("Dr Elizabeth Jillian Smith Esq.")
```

---

## Byte count style

Two implementations: `ByteCountFormatStyle` for `Int64` (Xcode 13+), and `Measurement<UnitInformationStorage>.FormatStyle.ByteCount` (Xcode 14+).

### Styles

| Style | Behavior |
|-------|----------|
| `.file` | Platform-specific file display |
| `.memory` | Platform-specific memory display |
| `.decimal` | 1000 bytes = 1 KB |
| `.binary` | 1024 bytes = 1 KB |

```swift
let tb: Int64 = 1_000_000_000_000

tb.formatted(.byteCount(style: .binary))  // "931.32 GB"
tb.formatted(.byteCount(style: .decimal)) // "1 TB"
tb.formatted(.byteCount(style: .file))    // "1 TB"
tb.formatted(.byteCount(style: .memory))  // "931.32 GB"
```

### Options

```swift
tb.formatted(.byteCount(style: .file, allowedUnits: .gb))                    // "931.32 GB"
tb.formatted(.byteCount(style: .file, allowedUnits: [.kb, .mb]))             // varies

Int64.zero.formatted(.byteCount(style: .file, spellsOutZero: true))          // "Zero kB"
Int64.zero.formatted(.byteCount(style: .file, spellsOutZero: false))         // "0 bytes"

Int64(1_000).formatted(.byteCount(style: .file, includesActualByteCount: true))
// "1 kB (1,000 bytes)"
```

### Measurement variant (Xcode 14+)

```swift
let tbMeasurement = Measurement(value: 1, unit: UnitInformationStorage.terabytes)
tbMeasurement.formatted(.byteCount(style: .file)) // "1 TB"
```

---

## URL style (Xcode 14+)

```swift
let url = URL(string: "https://apple.com")!
url.formatted()     // "https://apple.com"
url.formatted(.url) // "https://apple.com"
```

### Component display

Options per component: `.always`, `.never`, `.omitIfHTTPFamily`

```swift
let style = URL.FormatStyle(
    scheme: .always,
    user: .never,
    password: .never,
    host: .always,
    port: .always,
    path: .always,
    query: .never,
    fragment: .never
)
```

Conditional: `.displayWhen(_:matches:)`, `.omitWhen(_:matches:)`, `.omitSpecificSubdomains(_:includeMultiLevelSubdomains:)`

### Parsing

```swift
try URL.FormatStyle.Strategy(port: .defaultValue(80)).parse("http://www.apple.com")
// http://www.apple.com:80

try URL.FormatStyle.Strategy(port: .optional).parse("http://www.apple.com")
// http://www.apple.com

try URL.FormatStyle.Strategy(port: .required).parse("http://www.apple.com")
// throws error
```

---

## Custom FormatStyle

Implement the protocol for any conversion:

```swift
public protocol FormatStyle: Decodable, Encodable, Hashable {
    associatedtype FormatInput
    associatedtype FormatOutput

    func format(_ value: Self.FormatInput) -> Self.FormatOutput
    func locale(_ locale: Locale) -> Self
}
```

Make it available via dot syntax:

```swift
extension FormatStyle where Self == MyCustomStyle {
    static var myStyle: MyCustomStyle { .init() }
}

// Usage
value.formatted(.myStyle)
```

### ParseableFormatStyle (bidirectional)

To support parsing strings back into your type, conform to `ParseableFormatStyle`:

```swift
public protocol ParseableFormatStyle: FormatStyle {
    associatedtype Strategy: ParseStrategy
        where Strategy.ParseOutput == FormatInput, Strategy.ParseInput == FormatOutput

    var parseStrategy: Strategy { get }
}

public protocol ParseStrategy: Decodable, Encodable, Hashable {
    associatedtype ParseInput
    associatedtype ParseOutput

    func parse(_ value: ParseInput) throws -> ParseOutput
}
```

Built-in types that support parsing: numbers, percentages, currencies, dates (`Date.FormatStyle` and `Date.ISO8601FormatStyle`), person names, and URLs (iOS 16+).
