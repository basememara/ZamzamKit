//: Playground - noun: a place where people can play

import Foundation

func + <K,V> (left: Dictionary<K,V>, right: Dictionary<K,V>?) -> Dictionary<K,V> {
    guard let right = right else { return left }
    return left.reduce(right) {
        var new = $0 as [K:V]
        new.updateValue($1.1, forKey: $1.0)
        return new
    }
}

func += <K,V> (inout left: Dictionary<K,V>, right: Dictionary<K,V>?) {
    guard let right = right else { return }
    right.forEach { key, value in
        left.updateValue(value, forKey: key)
    }
}

let moreAttributes: [String:String] = ["Function":"authenticate"]
var attributes: [String:String] = ["File":"Auth.swift"]

attributes + moreAttributes + nil //["Function": "authenticate", "File": "Auth.swift"]    
attributes + moreAttributes //["Function": "authenticate", "File": "Auth.swift"]
attributes + nil //["File": "Auth.swift"]