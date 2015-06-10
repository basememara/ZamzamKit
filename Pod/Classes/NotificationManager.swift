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
    
    public var getAllUrl: String {
        get {
            return //ZamzamManager.sharedInstance.configurationService.getValue("BaseUrl")
                baseUrl
                + "/wp-json/posts?type=z-notification&filter[posts_per_page]=50&filter[orderby]=date&filter[order]=desc&page=1"
        }
    }
    
    public func populate(enableCache: Bool = true, completion: (() -> Void)? = nil) {
        let cacheParam = enableCache ? NSDate().stringFromFormat("yyyyMMdd") : "\(NSDate().timeIntervalSince1970)"
        
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
                var hasChanges = false
                if let entity = NotificationEntity.fromJSON(item, &hasChanges) where hasChanges {
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