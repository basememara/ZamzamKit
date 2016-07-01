# ZamzamKit

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/ZamzamKit.svg?style=flat)](http://cocoapods.org/pods/ZamzamKit)
[![Platform](https://img.shields.io/cocoapods/p/ZamzamKit.svg?style=flat)](http://cocoapods.org/pods/ZamzamKit)

ZamzamKit a Swift framework for rapid development using a collection of small utility extensions for NSFoundation and UIKit classes and protocols.

## Usage

###NSFoundation
####Array + get
```
// Before
if let items = tabBarController.tabBar.items where items.count > 4 {
    items[5].selectedImage = UIImage("my-image")
}
```
```
// After
tabBarController.tabBar.items?.get(5)?.selectedImage = UIImage("my-image")
```
####SCNetworkReachability + online
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
####NSBundle + contents
```
// Before
guard let contents = NSDictionary(contentsOfURL: bundleURL.URLByAppendingPathComponent("Settings.plist"))
    else { return [:] }
        
guard let preferences = contents.valueForKey("PreferenceSpecifiers") as? [String: AnyObject]
    else { return [:] }
        
let values: [String : AnyObject] = preferences
```
```
// After
let values = NSBundle.contentsOfFile("Settings.plist")
```
###UIKit
####UIViewController + alert
```
// Before
class MyViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        alert("My Title", message: "This is my message.") {
            print("OK tapped")
        }
    }
}
```
####UIViewController + Safari
```
// Before
class MyViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        presentSafariController(url)
    }
}
```
####UITableView/UICollectionView + subscript
```
// Before
let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
```
```
// After
let cell = tableView[indexPath]
```
####UIColors + hex
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
####UIColors + rgb
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
###Strings
####Regular Expressions
```
// Before
guard let regex: NSRegularExpression = try? NSRegularExpression(
    pattern: pattern,
    options: .CaseInsensitive) where self != "" else {
        return self
}
    
let length = self.characters.count

let newValue = regex.stringByReplacingMatchesInString(self, options: [],
    range: NSMakeRange(0, length),
    withTemplate: replaceValue)
```
```
// After
myString.replaceRegEx("([0][2-9]|[1-9][0-9])", replaceValue: "AAA")
```
####Validation
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
####HTML
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

####Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `ZamzamKit` by adding it to your `Cartfile`:
```
github "ZamzamInc/ZamzamKit"
```

## Author

Zamzam Inc., contact@zamzam.io

## License

ZamzamKit is available under the MIT license. See the LICENSE file for more info.
