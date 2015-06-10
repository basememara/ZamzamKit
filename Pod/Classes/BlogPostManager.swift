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

public class BlogPostManager: NSObject {
    
    let baseUrl = "http://naturesnurtureblog.com"
    let cacheParam = NSDate().stringFromFormat("yyyyMMdd")
    
    public var getAllUrl: String {
        get {
            return //ZamzamManager.sharedInstance.configurationService.getValue("BaseUrl")
                baseUrl
                + "/wp-json/posts?filter[post_status]=publish&filter[posts_per_page]=50&filter[orderby]=date&filter[order]=desc&page=1"
        }
    }
    
    public var getPopularUrl: String {
        get {
            return //ZamzamManager.sharedInstance.configurationService.getValue("BaseUrl")
                baseUrl
                + "/wp-json/popular_counts"
        }
    }
    
    public func populate(completion: (() -> Void)?) {
        // Retrieve seed file and store
        if let path = NSBundle.mainBundle().pathForResource("posts", ofType: "json"),
            let data = NSData(contentsOfFile: path) {
                store(data)
        }
        
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
                if let value = BlogPostEntity.fromJSON(item) {
                    updateCount++
                }
            }
            
            if updateCount > 0 {
                ZamzamManager.sharedInstance.dataContext.save()
            }
        }
        
        return updateCount
    }
    
    public func populatePopular(completion: (() -> Void)?) {
        // Get data from remote server
        Alamofire.request(.GET, getPopularUrl + "?cache=\(cacheParam)")
            .response { (request, response, data, error) in
                // Handle errors if applicable
                if(error != nil) {
                    NSLog("Error: \(error)")
                } else if let data = data as? NSData {
                    var updateCount = 0
                    
                    for (key: String, item: JSON) in JSON(data: data) {
                        if let id = item["ID"].string?.toInt(),
                            var post = ZamzamManager.sharedInstance.dataContext.blogPosts.first({ $0.id == Int32(id) }) {
                                let commentsCount = Int32(item["comments_count"].string?.toInt() ?? 0)
                                let viewsCount = Int32(item["views_count"].string?.toInt() ?? 0)
                                var updated = false
                                
                                // Updated comment count
                                if post.commentsCount < commentsCount {
                                    post.commentsCount = commentsCount
                                    updated = true
                                }
                                
                                // Updated comment count
                                if post.viewsCount < viewsCount {
                                    post.viewsCount = viewsCount
                                    updated = true
                                }
                                
                                if updated {
                                    updateCount++
                                }
                        }
                    }
                    
                    if updateCount > 0 {
                        ZamzamManager.sharedInstance.dataContext.save()
                    }
                }
                
                if completion != nil {
                    completion!()
                }
        }
    }
    
}