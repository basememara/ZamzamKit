# ZamzamKit

[![Build Status](https://api.travis-ci.org/ZamzamInc/ZamzamKit.svg?branch=master)](https://travis-ci.org/ZamzamInc/ZamzamKit)
[![Platform](https://img.shields.io/cocoapods/p/ZamzamKit.svg?style=flat)](https://github.com/ZamzamInc/ZamzamKit)
[![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-10.1-blue.svg)](https://developer.apple.com/xcode)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/ZamzamKit.svg?style=flat)](http://cocoapods.org/pods/ZamzamKit)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

ZamzamKit a Swift framework for rapid development using a collection of small utility extensions for Foundation and UIKit classes and protocols.

## Usage

### Foundation
<details>
<summary>Array</summary>
---
> Safely retrieve an element at the given index if it exists:
```swift
// Before
if let items = tabBarController.tabBar.items, items.count > 4 {
    items[3].selectedImage = UIImage("my-image")
}
```
```swift
// After
tabBarController.tabBar.items?.get(3)?.selectedImage = UIImage("my-image")

[1, 3, 5, 7, 9].get(1) -> Optional(3)
[1, 3, 5, 7, 9].get(12) -> nil
```

> Get distinct elements from an array:
```swift
[1, 1, 3, 3, 5, 5, 7, 9, 9].distinct -> [1, 3, 5, 7, 9]
```

> Remove an element from an array by the value:
```swift
var array = ["a", "b", "c", "d", "e", "a"]
array.remove("a")
array -> ["b", "c", "d", "e", "a"]
```

> Easily get the array version of an array slice:
```swift
["a", "b", "c", "d", "e"].prefix(3).array
```
</details>

<details>
<summary>Number</summary>
---
> Round doubles, floats, or any floating-point type:
```swift
123.12312421.rounded(toPlaces: 3) -> 123.123
Double.pi.rounded(toPlaces: 2) -> 3.14
```
</details>

<details>
<summary>Bundle</summary>
---
> Get the contents of a file within any bundle:
```swift
Bundle.main.string(file: "Test.txt") -> "This is a test. Abc 123.\n"
```

> Get the contents of a property list file within any bundle:
```swift
let values = Bundle.main.string(plist: "Settings.plist")
values["MyString1"] as? String -> "My string value 1."
values["MyNumber1"] as? Int -> 123
values["MyBool1"] as? Bool -> false
values["MyDate1"] as? Date -> 2018-11-21 15:40:03 +0000
```
</details>

<details>
<summary>Date</summary>
---
> A Gregorian calendar object with `UTC` time zone and `POSIX` locale used to normalize date calculations and data storage:
```swift
let calendar: Calendar = .gregorianUTC
```

> Determine if a date is in the past or future:
```swift
Date(timeIntervalSinceNow: -100).isPast -> true
Date(timeIntervalSinceNow: 100).isPast -> false

Date(timeIntervalSinceNow: 100).isFuture -> true
Date(timeIntervalSinceNow: -100).isFuture -> false
```

> Determine if a date is today, yesterday, or tomorrow:
```swift
Date().isToday -> true
Date(timeIntervalSinceNow: -90_000).isYesterday -> true
Date(timeIntervalSinceNow: 90_000).isTomorrow -> true
```

> Determine if a date is within a weekday or weekend period:
```swift
Date().isWeekday -> false
Date().isWeekend -> true
```

> Get the beginning or end of the day:
```swift
Date().startOfDay -> "2018/11/21 00:00:00"
Date().endOfDay -> "2018/11/21 23:59:59"
```

> Get the beginning or end of the month:
```swift
Date().startOfMonth -> "2018/11/01 00:00:00"
Date().endOfMonth -> "2018/11/30 23:59:59"
```

> Determine if a date is between two other dates:
```swift
let date = Date()
let date1 = Date(timeIntervalSinceNow: 1000)
let date2 = Date(timeIntervalSinceNow: -1000)
date.isBetween(date1, date2) -> true
```

> Determine if a date is beyond a specified time window:
```swift
let date = Date(fromString: "2018/03/22 09:40")
let fromDate = Date(fromString: "2018/03/22 09:30")

date.isBeyond(fromDate, bySeconds: 300) -> true
date.isBeyond(fromDate, bySeconds: 1200) -> false
```

> Create a date from a string:
```swift
Date(fromString: "2018/11/01 18:15")
```

> Format a time interval to display as a timer.
```swift
Date(fromString: "2016/03/22 09:45").timerString(
    from: Date(fromString: "2016/03/22 09:40")
)

// Prints "00:05:00"
```

> Format a date to a string:
```swift
Date().string(format: "MMM d, h:mm a") -> "Jan 3, 8:43 PM"
```

> Increment years, months, days, hours, or minutes:
```swift
Date().increment(years: 1)
Date().increment(months: 2)
Date().increment(days: -4)
Date().increment(hours: 6)
Date().increment(minutes: 12)
```

> Get the decimal representation of the time:
```swift
Date(fromString: "2018/10/23 18:15").timeToDecimal -> 18.25
```
</details>

### Foundation

#### SCNetworkReachability + online
```
// Before
var zeroAddress = sockaddr_in()
zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
zeroAddress.sin_family = sa_family_t(AF_INET)

guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
    SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
}) else { return false }

var flags : SCNetworkReachabilityFlags = []
if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
    return false
}

let isReachable = flags.contains(.Reachable)
let needsConnection = flags.contains(.ConnectionRequired)
let isOnline = isReachable && !needsConnection
```
```
// After
let isOnline = SCNetworkReachability.isOnline
```
#### SequenceType + json
```
// Before
guard let data = myModel as? [[String: Any]],
    let stringData = try? NSJSONSerialization.dataWithJSONObject(data, options: [])
        else { return nil }

let json = NSString(data: stringData, encoding: NSUTF8StringEncoding) as? String
```
```
// After
let json = myModel.jsonString
```
#### Bundle + contents
```
// Before
guard let contents = NSDictionary(contentsOfURL: bundleURL.URLByAppendingPathComponent("Settings.plist"))
    else { return [:] }
        
guard let preferences = contents.valueForKey("PreferenceSpecifiers") as? [String: Any]
    else { return [:] }
        
let values: [String : Any] = preferences
```
```
// After
let values = NSBundle.contentsOfFile(plistName: "Settings.plist")
```
#### Bundle + string
```
// Before
guard let resourcePath = (bundle ?? NSBundle.mainBundle()).pathForResource(fileName, ofType: nil, inDirectory: inDirectory)
    else { return nil }

let value = try? String(contentsOfFile: resourcePath, encoding: encoding)
```
```
// After
let value = NSBundle.stringOfFile(fileName: "my-test-file.txt")
```
### UIKit
#### UIViewController + alert
```
// Before
class MyViewController: UIViewController {
    func something() {
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { alert in
            print("OK tapped")
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
```
```
// After
class MyViewController: UIViewController {
    func something() {
        presentAlert("My Title", message: "This is my message.") {
            print("OK tapped")
        }
    }
}
```
#### UIViewController + Safari
```
// Before
class MyViewController: UIViewController {
    func something() {
        let safariController = SFSafariViewController(URL: NSURL(string: url)!)
        safariController.modalPresentationStyle = .OverFullScreen
        safariController.delegate = self as? SFSafariViewControllerDelegate
        presentViewController(safariController, animated: true, completion: nil)
    }
}
```
```
// After
class MyViewController: UIViewController {
    func something() {
        presentSafariController(url)
    }
}
```
#### UITableView/UICollectionView + subscript
```
// Before
let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
```
```
// After
let cell = tableView[indexPath]
```
#### UIColors + hex
```
// Before
let hexColor = UIColor(
    red: CGFloat((0x990000 & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((0x990000 & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(0x990000 & 0x0000FF) / 255.0,
    alpha: CGFloat(1)
```
```
// After
let hexColor = UIColor(hex: 0x990000)
```
#### UIColors + rgb
```
// Before
let rgbColor = UIColor(
    red: CGFloat(255) / 255.0,
    green: CGFloat(128) / 255.0,
    blue: CGFloat(102) / 255.0,
    alpha: CGFloat(1)
```
```
// After
let rgbColor = UIColor(rgb: (255, 128, 102))
```
#### CLLocation + meta
```
// Before
CLGeocoder().reverseGeocodeLocation(myLocation) { placemarks, error in
    // Validate values
    guard let mark = placemarks?[0] where error == nil else {
        return handler(locationMeta: nil)
    }
    
    // Get timezone if applicable
    var timezone: String?
    if mark.description != "" {
        let desc = mark.description
        
        // Extract timezone description
        if let regex = try? NSRegularExpression(
            pattern: "identifier = \"([a-z]*\\/[a-z]*_*[a-z]*)\"",
            options: .CaseInsensitive),
            let result = regex.firstMatchInString(desc, options: [], range: NSMakeRange(0, desc.characters.count)) {
                let tz = (desc as NSString).substringWithRange(result.rangeAtIndex(1))
                timezone = tz.stringByReplacingOccurrencesOfString("_", withString: " ")
        }
    }
    
    print("coordinates: \(myLocation.coordinate.latitude), \(myLocation.coordinate.longitude)")
    print("locality: \(mark.locality)")
    print("country: \(mark.country)")
    print("countryCode: \(mark.ISOcountryCode)")
    print("timezone: \(timezone)")
    print("administrativeArea: \(mark.administrativeArea)")
}
```
```
// After
myLocation.getMeta { locationMeta in
    print("coordinates: \(locationMeta.coordinates.latitude), \(locationMeta.coordinates.longitude)")
    print("locality: \(locationMeta.locality)")
    print("country: \(locationMeta.country)")
    print("countryCode: \(locationMeta.countryCode)")
    print("timezone: \(locationMeta.timezone)")
    print("administrativeArea: \(locationMeta.administrativeArea)")
}
```
### Strings
#### Localization
```
// Before
NSLocalizedString(myString, comment: "")
```
```
// After
myString.localized
```
#### Regular Expressions
```
// Before
guard let regex: NSRegularExpression = try? NSRegularExpression(
    pattern: pattern,
    options: .CaseInsensitive) where myString != "" else {
        return myString
}
    
let length = myString.characters.count

let newValue = regex.stringByReplacingMatchesInString(myString, options: [],
    range: NSMakeRange(0, length),
    withTemplate: replaceValue)
```
```
// After
myString.replaceRegEx("([0][2-9]|[1-9][0-9])", replaceValue: "AAA")
```
#### Validation
```
// Before
do {
    let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: [.CaseInsensitive])
    let isEmail = regex.firstMatchInString(myString, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
} catch {
    return false
}
```
```
// After
myString.isEmail
myString.isNumber
myString.isAlpha
myString.isAlphaNumeric
```
#### HTML
```
// Before
myDiv.stringByReplacingOccurrencesOfString("<[^>]+>",
    withString: "",
    options: .RegularExpressionSearch,
    range: nil)
```
```
// After
myDiv.stripHTML()
```
And more!

## Installation

#### Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `ZamzamKit` by adding it to your `Cartfile`:
```
github "ZamzamInc/ZamzamKit"
```

#### CocoaPods
Add `pod "ZamzamKit"` to your `Podfile`.

## Author

Zamzam Inc., http://zamzam.io

## License

ZamzamKit is available under the MIT license. See the LICENSE file for more info.
