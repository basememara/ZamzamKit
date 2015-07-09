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
        var err: NSError?
        var regex: NSRegularExpression = NSRegularExpression(
            pattern: pattern,
            options: NSRegularExpressionOptions.CaseInsensitive,
            error: &err)!
        var length = count(value)
        
        return regex.stringByReplacingMatchesInString(value, options: nil,
            range: NSMakeRange(0, length),
            withTemplate: replaceValue)
    }
    
}
