//: Playground - noun: a place where people can play

import UIKit

let date1 = NSDate(timeIntervalSinceNow: -60)
let seconds = NSDate().timeIntervalSinceDate(date1)
print(seconds)