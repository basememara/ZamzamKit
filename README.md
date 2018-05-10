# ZamzamKit

[![Build Status](https://api.travis-ci.org/ZamzamInc/ZamzamKit.svg?branch=master)](https://travis-ci.org/ZamzamInc/ZamzamKit)
[![Platform](https://img.shields.io/cocoapods/p/ZamzamKit.svg?style=flat)](https://github.com/ZamzamInc/ZamzamKit)
[![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-9.3-blue.svg)](https://developer.apple.com/xcode)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/ZamzamKit.svg?style=flat)](http://cocoapods.org/pods/ZamzamKit)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

ZamzamKit a Swift framework for rapid development using a collection of small utility extensions for NSFoundation and UIKit classes and protocols.

## Usage

### Foundation
#### Array + get
```
// Before
if let items = tabBarController.tabBar.items where items.count > 4 {
    items[3].selectedImage = UIImage("my-image")
}
```
```
// After
tabBarController.tabBar.items?.get(3)?.selectedImage = UIImage("my-image")
```
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
And more! See the [API documentation here](https://cdn.rawgit.com/ZamzamInc/ZamzamKit/master/docs/index.html).

## Installation

#### Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `ZamzamKit` by adding it to your `Cartfile`:
```
github "ZamzamInc/ZamzamKit"
```

#### CocoaPods
Add `pod "ZamzamKit"` to your `Podfile`.

## Author

http://zamzam.io

## License

ZamzamKit is available under the MIT license. See the LICENSE file for more info.
