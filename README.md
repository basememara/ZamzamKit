# ZamzamKit

[![Platform](https://img.shields.io/badge/platform-macos%20%7C%20ios%20%7C%20watchos%20%7C%20ipados-lightgrey)](https://github.com/basememara/ZamzamKit)
[![Swift](https://img.shields.io/badge/Swift-6-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-27-blue.svg)](https://developer.apple.com/xcode)
[![SPM](https://img.shields.io/badge/SPM-Compatible-blue)](https://swift.org/package-manager)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

ZamzamKit is a Swift package of small utilities and extensions over the standard library, Foundation, SwiftUI and other Apple frameworks. It has no dependencies.

## Installation

### Swift Package Manager

`.package(url: "https://github.com/basememara/ZamzamKit.git", .upToNextMajor(from: "8.0.0"))`

The package has four products. Add the ones you use to your target's dependencies, and import each module by its own name:

```swift
.target(
    name: "MyAppExample",
    dependencies: [
        .product(name: "ZamzamCore", package: "ZamzamKit"),
        .product(name: "ZamzamLocation", package: "ZamzamKit"),
        .product(name: "ZamzamNotification", package: "ZamzamKit"),
        .product(name: "ZamzamUI", package: "ZamzamKit"),
    ]
)
```

| Product | Holds | Depends on |
|---|---|---|
| `ZamzamCore` | Extensions, networking, logging, keychain, utilities | No other product |
| `ZamzamLocation` | `LocationManager` | ZamzamCore |
| `ZamzamNotification` | `UNUserNotificationCenter` extensions | ZamzamCore |
| `ZamzamUI` | SwiftUI modifiers, sheets, styles and views | ZamzamCore |

Requirements: macOS 14, iOS 17 or watchOS 10, and the Swift 6 language mode (`swift-tools-version: 6.0`). Every target builds under strict concurrency.

A breaking change to public API waits for the next major version. If you are on 7, read [Moving from 7 to 8](#moving-from-7-to-8).

Agent-driven maintenance (build and test loop, conventions, consumer contract) is documented in [AGENTS.md](AGENTS.md).

## ZamzamCore

### Collections

```swift
[1, 2, 3, 4, 5].chunked(into: 2) // [[1, 2], [3, 4], [5]]
[1, 3, 3, 5, 7, 9].removeDuplicates() // [1, 3, 5, 7, 9]
["a", "b", "c"][safe: 5] // nil
["a", "b", "c"].prefix(2).array // ["a", "b"]

var letters = ["a", "b", "c", "a"]
letters.remove("a") // ["b", "c", "a"]

let items: [String]? = nil
items.isNilOrEmpty // true
```

Sort by a key path, read a dictionary with a stored default, and step through the cases of an enum:

```swift
people.sorted(by: \.name)
people.sorted(by: \.age, >)

var counts = ["abc": 123]
counts["lmn", initial: 555] // 555, and stored under "lmn"
counts.jsonString() // {"abc":123,"lmn":555}, keys in any order

enum Direction: CaseIterable {
    case north, east, south, west
}

Direction.east.previous() // .north
Direction.west.next() // nil
```

### Strings

Integer subscripts count characters from the start and return `nil` out of bounds:

```swift
let value = "Abcdef123456"
value[3] // "d"
value[3...6] // "def1"
value[3..<99] // "def123456"
value[99] // nil

value.truncated(3) // "Abc..."
"1234567890".separated(every: 2, with: "-") // "12-34-56-78-90"
" Abcdef123456 \n".trimmed // "Abcdef123456"
"a-b-c".replacingLastOccurrence(of: "-", with: "+") // "a-b+c"
"a b\nc".strippingCharacters(in: .whitespacesAndNewlines) // "abc"
String(random: 4, prefix: "PIN-") // "PIN-uSjm"
```

Encoding, decoding and optional checks:

```swift
"Abc".base64Encoded() // "QWJj"
"QWJj".base64Decoded() // "Abc"
"4 &lt; 5 &amp; 12 &#x20ac;".htmlDecoded() // "4 < 5 & 12 €"

let name: String? = "  "
name.isNilOrEmpty // false
name.isNilOrBlank // true
```

### Numbers

```swift
Double.pi.rounded(toPlaces: 2) // 3.14
```

### Dates

Nothing reads the device's calendar, time zone or clock on its own. Every calculation takes the calendar, which carries the time zone:

```swift
let calendar = Calendar(identifier: .gregorian, timeZone: .gmt)

guard let date = Date(year: 2018, month: 11, day: 1, hour: 18, minute: 15, calendar: calendar) else { return }

date.startOfDay(using: calendar) // Nov 1, 2018, 00:00:00
date.endOfMonth(using: calendar) // Nov 30, 2018, 23:59:59
date.tomorrow(using: calendar) // Nov 2, 2018, 18:15:00
date.timeToDecimal(using: calendar) // 18.25
date.shortString(calendar: calendar) // "2018-11-01"
date.isBetween(date - .hours(1), date + .hours(1)) // true
```

Add calendar units with the calendar, and minutes or hours without one:

```swift
date + .days(3, calendar)
date - .months(1, calendar)
date + .minutes(90)

var reminder = date
reminder += .weeks(1, calendar)
```

Intervals, weeks and formatters:

```swift
let interval = DateInterval(start: date, duration: 3600)
interval.progress(at: date + .minutes(15)) // (value: 0.25, remaining: 2700)
interval.stride(by: 1200) // four dates, 20 minutes apart

calendar.generateWeek(for: date) // seven dates, the first moment of each day in the date's week
date.expanding(to: .monthWithTrailingWeeks, using: calendar) // November widened to whole weeks, as a month grid shows it

DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm", calendar: calendar, locale: .posix).string(from: date)
// "2018-11-01T18:15"
```

Hijri dates are read on the Umm al-Qura calendar, in the time zone you pass:

```swift
let timeZone = TimeZone.gmt

guard let holiday = Date(year: 2017, month: 6, day: 26, calendar: calendar) else { return }

holiday.hijriString(timeZone: timeZone, locale: Locale(identifier: "en_US")) // "Shawwal 2, 1438"
holiday.hijri(timeZone: timeZone).month // 10
holiday.isEid(timeZone: timeZone) // true
holiday.isRamadan(offset: -3, timeZone: timeZone) // true, three days earlier
holiday.isJumuah(using: calendar) // false, a Monday
```

### Data and JSON

```swift
struct User: Codable {
    let id: Int
    let name: String
}

let data = try User(id: 1, name: "Sam").encode()
let user: User = try data.decode()
let other: User = try #"{"id": 2, "name": "Lee"}"#.decode()

data.string // {"id":1,"name":"Sam"}, keys in any order
data.hexString()
data.base64URLEncodedString()
```

`AnyDecodable` decodes JSON whose shape isn't known ahead of time:

```swift
let json = #"{"count": 3, "tags": ["a", "b"], "active": true}"#
let values = try JSONDecoder().decode([String: AnyDecodable].self, from: json)

values["count"]?.value // 3
values["tags"]?.value // ["a", "b"]
```

### URLs and requests

`URL(safeString:)` takes a string literal only, for an address written in the source. A string made at run time goes through `URL(string:)`.

```swift
let url = URL(safeString: "https://example.com/files/report.json")
url.replacingPathExtension("xml") // https://example.com/files/report.xml
url.appendingToFileName("-2") // https://example.com/files/report-2.json
```

`URLRequest` gains initializers for JSON APIs. GET and DELETE send the parameters in the query string, and every other method sends them as a JSON body:

```swift
let request = URLRequest(
    url: URL(safeString: "https://example.com/users"),
    method: .post,
    parameters: ["name": "Sam", "age": 30],
    headers: ["X-Client": "ios"],
    authentication: .bearer(token)
)
```

### Networking

`NetworkManager` sends a request through a `NetworkService` and returns the response, or the decoded body. `NetworkServiceFoundation` runs on `URLSession` and throws a `NetworkError` when the connection fails or the status is outside 200 to 299.

```swift
let network = NetworkManager(service: NetworkServiceFoundation())

do {
    let users: [User] = try await network.send(request)
    print(users.count)
} catch let error as NetworkError {
    print(error.statusCode ?? 0, ZamzamError(from: error))
} catch {
    print(error)
}
```

Pin a certificate for a host, or change every request on its way out with a `URLRequestAdapter`:

```swift
let service = NetworkServiceFoundation(
    serverTrustEvaluators: [
        "example.com": NetworkPinnedCertificateTrustEvaluator(certificateURLs: [certificateURL])
    ]
)

struct ClientHeader: URLRequestAdapter {
    func adapt(_ request: URLRequest) -> URLRequest {
        var request = request
        request.setValue("ios", forHTTPHeaderField: "X-Client")
        return request
    }
}

let pinned = NetworkManager(service: service, adapter: ClientHeader())
```

### Logging

`LogManager` sends each entry to every `LogService` whose minimum level allows it. Three services ship: the console, the system log, and a file that rotates at 5 MB (2 MB on watchOS).

```swift
let log = LogManager(
    services: [
        LogServiceConsole(minLevel: .debug, subsystem: "MyApp"),
        LogServiceOS(minLevel: .info, subsystem: "com.example.MyApp", category: "App", isDebug: false),
        LogServiceFile(minLevel: .info, subsystem: "MyApp", fileURL: logURL, sessionKeys: ["user_id"])
    ]
)

log.set("12345", forKey: "user_id")
log.info("Signed in", context: ["plan": "free"])
log.error("Sync failed", error: error)
```

For another destination, conform a type to `LogService` with a `minLevel` and a `write` method.

### Keychain

```swift
extension KeychainAPI.Key {
    static let token = KeychainAPI.Key("token")
}

let keychain: KeychainService = KeychainServiceExternal()

keychain.set("abc123", forKey: .token)
let token: String? = keychain.get(.token)
keychain.remove(.token)
```

### Core Location helpers

```swift
let toronto = CLLocationCoordinate2D(latitude: 43.7, longitude: -79.4)
let ottawa = CLLocationCoordinate2D(latitude: 45.4, longitude: -75.7)

toronto.distance(from: ottawa) // meters
[toronto, ottawa].closest(to: ottawa) // ottawa

let place = await toronto.location.geocoder(timeout: 5)
place?.locality // the city's name

CLLocationManager().isAuthorized
```

### Application

`AppMigration` runs a block once per app version:

```swift
AppMigration()
    .performUpdate {
        // Runs once after every update
    }
    .perform(forVersion: "1.7") {
        // Runs once, the first time version 1.7 or later launches
    }
```

`Distribution` reads the main bundle, and `BackgroundTask` (iOS) keeps the app running to finish work:

```swift
struct AppDetails: Distribution {}

let details = AppDetails()
details.appVersion // "1.7"
details.isInTestFlight // false
details.platform // "iOS"

BackgroundTask.run(for: application) { task in
    // Finish the work, then:
    task.end()
}
```

### Utilities

```swift
// Set up a new object in place
let decoder = JSONDecoder().apply {
    $0.keyDecodingStrategy = .convertFromSnakeCase
}

// Assign only when the right side isn't nil
var title = "Untitled"
title ?= response.title

// Debounce or throttle work
let limiter = Limiter(policy: .debounce, duration: 0.5)
await limiter.run { await search(for: text) }

// Keep a string out of plain sight in the binary. It is not encryption.
let obfuscator = Obfuscator(salt: "a value that does not change")
let bytes = obfuscator.conceal(secret: "your_secret") // debug builds only
obfuscator.reveal(secret: bytes) // "your_secret"
```

Smaller pieces: `Bundle.main.string(file:)` and `Bundle.main.data(forResource:withExtension:)`, `Locale.posix` and `Calendar.posix` for fixed formats, `Locale.languageName`, `NotificationCenter.default.post(name:userInfo:)`, and on macOS the `NSColor` names that match iOS (`label`, `secondaryLabel`, `systemBackground`, `tertiarySystemBackground`).

## ZamzamLocation

`LocationManager` wraps Core Location in async calls on the main actor: permission, one location, and a stream of headings (iOS and watchOS).

```swift
let locationManager = LocationManager()

switch await locationManager.currentLocation() {
case let .success(location):
    print(location.coordinate)
case .failure(.denied):
    print("Location access is off")
case .failure(.unavailable):
    print("No location yet")
}

for await result in locationManager.headings() {
    if case let .success(heading) = result {
        print(heading.trueHeading)
    }
}
```

`currentLocation()` asks for when-in-use permission first when the user hasn't decided, and falls back to the last known location after its timeout. `requestAuthorization()`, `isAuthorized` and `canRequestAuthorization` are there when you want the steps apart.

## ZamzamNotification

Extensions on `UNUserNotificationCenter` to register, schedule, find and remove local notifications.

```swift
let center = UNUserNotificationCenter.current()

let granted = await center.register(
    category: "reminders",
    actions: [UNNotificationAction(identifier: "doneAction", title: "Done", options: [])]
)

// After a delay, once at a date, and every day at the date's time on a calendar
try await center.add(timeInterval: 300, body: "Tea is ready", identifier: "tea")
try await center.add(date: date, body: "Meeting starts", category: "reminders")
try await center.add(date: date, repeats: .day, calendar: calendar, body: "Daily review", category: "reminders")
```

```swift
await center.exists(withIdentifier: "tea") // true
await center.get(withCategory: "reminders", pendingOnly: true) // two requests

center.remove(withIdentifier: "tea")
await center.removePending(withCategory: "reminders")
center.removeAll()
```

`register` replaces the center's categories with the ones you pass. A repeating time interval under a minute throws `ZamzamError.invalidData`.

## ZamzamUI

### Modifiers

```swift
List(places) { place in
    Text(redactable: place.name)
        .rowActions {
            Button("Refresh", systemImage: "location", action: refresh)
        }
}
.redacted(if: isLoading)
.progress(if: isLoading)
.onLoad { await load() }
.onForeground { await load() }
.onNotification(for: .placesDidChange) { await load() }
.alert(error: $error)
```

- `onLoad(perform:)` runs once, the first time the view appears. `onForeground(perform:)` runs each time the scene returns from the background.
- `rowActions` are swipe actions on iOS and watchOS, and a context menu on macOS.
- `alert(error:)` shows a `ViewError`, which holds a title, a message and up to two actions.
- `modifier(if:then:)`, `modifier(if:then:else:)` and `modifier(let:then:)` apply a modifier on a condition or an optional. `hidden(_:)` hides a view and keeps its place; `removed(if:)` takes it out of the hierarchy.
- `border(_:width:cornerRadius:)` clips to a rounded rectangle and strokes it.

```swift
error = ViewError(
    title: "Could not save",
    message: "Check your connection and try again.",
    action: ViewError.Action("Retry") { retry() }
)
```

### Sheets (iOS)

```swift
Button("Open link") {
    linkURL = URL(string: "https://apple.com")
}
.sheet(safari: $linkURL)

Button("Send feedback") {
    mail = MailItem(
        emails: "support@example.com",
        subject: "Feedback",
        attachments: [MailItem.Attachment(data: logData, mimeType: "text/plain", fileName: "app.log")]
    )
}
.sheet(mail: $mail)
```

`open(itunesID:application:)` presents an App Store page over the key window.

### Styles and views

`CardStyle`, `ImageStyle`, `TextStyle` and `ThemeStyle` are view modifier protocols, so a design system can name its styles and apply them with `cardStyle(_:)`, `imageStyle(_:)`, `textStyle(_:)` and `themeStyle(_:)`:

```swift
struct PrimaryCardStyle: CardStyle {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.background.secondary, in: .rect(cornerRadius: 12))
    }
}

AdaptiveStack {
    Text("Fajr")
    Text("5:42 AM")
}
.cardStyle(PrimaryCardStyle())
```

`AdaptiveStack` is horizontal, and turns vertical at text sizes above extra large.

Also in the module: `Button` initializers that take an async action, `Label`, `Button` and `TextField` initializers that take a `Text`, `TimelineSchedule.openEnded(_:)` for an explicit schedule that goes idle after its last date, and `LogManager.set(context:)` to record the scene phase on every log entry.

## Moving from 7 to 8

8.0.0 is a clean break: about a quarter of the code is gone, with no deprecation step. What is left reads no calendar, time zone or clock on its own, and no public function stops the program on a value met at run time.

### The umbrella product

The `ZamzamKit` product is gone. It re-exported nothing, so `import ZamzamKit` gave you no API. Depend on the products you use and import them by name: `ZamzamCore`, `ZamzamLocation`, `ZamzamNotification`, `ZamzamUI`.

### Removed, with a platform replacement

| Removed | Use |
|---|---|
| `Data.sha256()`, `String.sha256()`, `Digest.bytes`, `Digest.data` | CryptoKit: `SHA256.hash(data:)` |
| `CaseIterable.index()` | `allCases.firstIndex(of:)` |
| `Result.error` | `if case let .failure(error) = result` |
| `Array.prepend(_:)` | `insert(_:at:)` with index 0 |
| `Zip2Sequence.array` | `Array(zip(a, b))` |
| `Locale.characterDirection` | `locale.language.characterDirection` |
| `FileManager` helpers `url(of:from:)`, `path(of:from:)`, `urls(from:filter:)`, `paths(from:filter:)` | `URL.documentsDirectory` and its siblings, `FileManager.contentsOfDirectory(at:includingPropertiesForKeys:)` |
| `Bundle.contents(plist:)`, `Bundle.array(plist:)` | `PropertyListDecoder` over `Bundle.data(forResource:withExtension:)` |
| `JSONDecoder(dateFormatter:)` | Set `dateDecodingStrategy` to `.formatted(_:)` |
| `decode()`, `decode(forKey:)` and `decodeIfPresent(forKey:)` without a type | The container's own methods, with the type: `decode(_:forKey:)` |
| `NotificationCenter.addObserver(_:selector:name:)`, `removeObserver(_:name:)` | `notifications(named:)`, or Foundation's own methods with `object:` |
| `String.isEmail`, `isNumber`, `isAlpha`, `isAlphaNumeric`, `contains(_: CharacterSet)`, `match(regex:)`, `replacing(regex:with:caseSensitive:)` | `Regex`: `wholeMatch(of:)`, `contains(_:)`, `replacing(_:with:)` |
| `String.urlEncoded()`, `urlDecoded()` | `addingPercentEncoding(withAllowedCharacters:)`, `removingPercentEncoding` |
| `URL.appendingQueryItem(_:value:)`, `appendingQueryItems(_:)`, `removeQueryItem(_:)`, `queryItem(_:)` | `URL.appending(queryItems:)`, `URLComponents.queryItems` |
| `Shape.fill(_:stroke:lineWidth:)` | Chain `fill(_:)` and `stroke(_:lineWidth:)` on the shape |
| `CurrencyFormatter` | `formatted(.currency(code:))` |
| `@Defaults`, `@DefaultsOptional`, `UserDefaultsRepresentable`, `UserDefaults.contains(_:)` | `@AppStorage`, or `UserDefaults` directly |
| `DateFormatter.iso8601Formatter`, `zuluFormatter`, `dateFormat8601`, `dateFormatZ`, `DateFormatter(iso8601Format:)` | `Date.ISO8601FormatStyle` |
| `DateFormatter(dateStyle:timeStyle:)`, the `"\(date, formatter: formatter)"` interpolation | `date.formatted(date:time:)` |
| `TimeZone.posix`, `isCurrent`, `offsetFromCurrent` | `TimeZone.gmt`; compare with `TimeZone.current` at the call site |
| `SCNetworkReachability.isOnline` | `NWPathMonitor` |
| `Date` checks `isToday`, `isYesterday`, `isTomorrow`, `isWeekday`, `isWeekend`, `isCurrentWeek`, `isCurrentMonth`, `isCurrentYear`, as properties and with `using:`, and `inSameDay(as:)` | `Calendar`: `isDateInToday(_:)`, `isDateInYesterday(_:)`, `isDateInTomorrow(_:)`, `isDateInWeekend(_:)`, `isDate(_:equalTo:toGranularity:)`, `isDate(_:inSameDayAs:)` |
| `Date.isPast`, `isFuture` | Compare with `Date.now` |
| `Date.islamicCalendar`, `islamicCalendarIdentifiers` | `Calendar(identifier: .islamicUmmAlQura, timeZone:)` |

### Removed outright

- `LogServiceHTTP`, `LogServiceDataDog` and `LogServicePapertrail`. For a vendor, write a `LogService`.
- The `Distribution` device properties: `deviceIdentifier`, `deviceModel`, `deviceName`, `manufacturer`, `osName`, `osVersion`. `platform` stays.
- `Audible` and `AudibleApplication`.
- `PlatformColor` and the color initializers `init(hex:alpha:)`, `init(rgb:alpha:)` and `random`. The `NSColor` names that match iOS stay.
- `String.htmlStripped`. `htmlDecoded()` stays.
- `LocationMeta.description` and `CLLocationCoordinate2D.description`.

### Changed signatures

| 7 | 8 |
|---|---|
| `URL(safeString: someString)` | `URL(safeString:)` takes a `StaticString`, so only a literal compiles. Use `URL(string:)` for a string made at run time. |
| `Date(year:month:day:…, timeZone:, calendar: = .current)` | `calendar:` is required and carries the time zone. `timeZone:` is gone. |
| `date.yesterday`, `tomorrow`, `startOfDay`, `endOfDay`, `startOfMonth`, `endOfMonth`, `startOfYear`, `endOfYear`, `timeToDecimal`, `isJumuah` | The forms that take the calendar: `date.startOfDay(using: calendar)` |
| `date + .days(1)`, `.weeks`, `.months`, `.years` | `date + .days(1, calendar)`. `.minutes` and `.hours` are unchanged. |
| `hijri(offSet:timeZone:calendar:)`, `hijriString(…)`, `isRamadan(offSet:timeZone:)`, `isEid(offSet:timeZone:)` | The label is `offset:`, `timeZone:` is required, and `calendar:` is gone. `hijriString` takes a `locale:`, the device's by default. |
| `shortString(timeZone:calendar:locale:)` | `shortString(calendar:)`, always in ASCII digits |
| `expanding(to:using: = .current)` | `using:` is required |
| `DateInterval.progress` | `progress(at:)` |
| `add(date:…, repeats: = .once, calendar: = .current)` on `UNUserNotificationCenter` | `add(date:…)` schedules once and takes no calendar. A repeating one is `add(date:repeats:calendar:…)`, and `ScheduleInterval.once` is gone. |
| `add(timeInterval:…, repeats: true)` under 60 seconds | Throws `ZamzamError.invalidData` |
| `MailItem(…, attachment:)` | `MailItem(…, attachments:)`, an array |

Three results changed with no change at the call site: `sheet(safari:)` presents nothing for a URL that isn't HTTP or HTTPS, a `URLRequest` whose parameters JSON can't hold has no body, and the keychain writes its items as readable after the first unlock (items already stored keep their setting until rewritten).

## Testing

Tests live flat in `Tests/` and run with `swift test`. In Xcode, the shared `ZamzamKit-Package` scheme runs `Package.xctestplan` at the package root, with code coverage for the four library targets. The plan runs every test twice, once with the defaults and once in Arabic (Saudi Arabia) on Auckland time, and the suite calls no live service.

## Author

* Basem Emara, https://zamzam.io

## License

`ZamzamKit` is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
