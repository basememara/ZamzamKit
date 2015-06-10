//
//  BlogPostManager.swift
//  Pods
//
//  Created by Basem Emara on 6/9/15.
//
//

import Foundation
import UIKit
import SwiftyJSON
import AlecrimCoreData
import Alamofire
import Timepiece
import ZamzamKit

public class NotificationManager: NSObject {
    
    let baseUrl = "http://naturesnurtureblog.com"
    let cacheParam = NSDate().stringFromFormat("yyyyMMdd")
    
    public var getAllUrl: String {
        get {
            return //ZamzamManager.sharedInstance.configurationService.getValue("BaseUrl")
                baseUrl
                + "/wp-json/posts?type=z-notification&filter[post_status]=publish&filter[posts_per_page]=50&filter[orderby]=date&filter[order]=desc&page=1"
        }
    }
    
    public func populate(completion: (() -> Void)? = nil) {
        // Get data from remote server for new updates beyond seed file
        Alamofire.request(.GET, getAllUrl + "&cache=\(cacheParam)")
            .response { (request, response, data, error) in
                // Handle errors if applicable
                if(error != nil) {
                    NSLog("Error: \(error)")
                } else {
                    self.store(data as? NSData)
                }
                
                if completion != nil {
                    completion!()
                }
        }
    }
    
    public func store(data: NSData?) -> Int {
        var updateCount = 0
        
        if let data = data {
            for (key: String, item: JSON) in JSON(data: data) {
                if let value = NotificationEntity.fromJSON(item) {
                    updateCount++
                }
            }
            
            if updateCount > 0 {
                ZamzamManager.sharedInstance.dataContext.save()
            }
        }
        
        return updateCount
    }
    
}