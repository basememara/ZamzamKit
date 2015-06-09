//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class WebService: NSObject {
    
    public func decodeHTML(value: String) -> String {
        let encodedData = value.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions: [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = NSAttributedString(
            data: encodedData,
            options: attributedOptions,
            documentAttributes: nil,
            error: nil)!
        
        return attributedString.string
    }
    
}
