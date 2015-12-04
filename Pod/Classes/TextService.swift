//
//  TextService.swift
//  Pods
//
//  Created by Basem Emara on 7/7/15.
//
//

import Foundation

public class TextService: NSObject {
    
    public func replaceRegEx(value: String, pattern: String, replaceValue: String) -> String {
        let regex: NSRegularExpression = try! NSRegularExpression(
            pattern: pattern,
            options: NSRegularExpressionOptions.CaseInsensitive)
        let length = value.characters.count
        
        return regex.stringByReplacingMatchesInString(value, options: [],
            range: NSMakeRange(0, length),
            withTemplate: replaceValue)
    }
    
}
