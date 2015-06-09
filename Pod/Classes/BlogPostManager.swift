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
    
    public var jsonUrl: String {
        get {
            return //ZamzamManager.sharedInstance.configurationService.getValue("BaseUrl")
                "http://naturesnurtureblog.com"
                + "/wp-json/posts?filter[post_status]=publish&filter[posts_per_page]=50&filter[orderby]=date&filter[order]=desc&page=1"
        }
    }
    
    public func load() {
        let cacheParam = NSDate().stringFromFormat("yyyyMMdd") // Daily cache param
        
        // Retrieve seed file and store
        if let path = NSBundle.mainBundle().pathForResource("posts", ofType: "json"),
            let data = NSData(contentsOfFile: path) {
                store(data)
        }
        
        // Get data from remote server for new updates beyond seed file
        Alamofire.request(.GET, jsonUrl + "&cache=\(cacheParam)")
            .response { (request, response, data, error) in
                // Handle errors if applicable
                if(error != nil) {
                    NSLog("Error: \(error)")
                } else {
                    self.store(data as? NSData)
                }
        }
    }
    
    public func store(data: NSData?) -> Int {
        var updateCount = 0
        
        if let data = data {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            for (key: String, item: JSON) in JSON(data: data) {
                if item.type != .Null {
                    var post = ZamzamManager.sharedInstance.dataContext.blogPosts.firstOrCreated { $0.id == item["ID"].int32 }
                    
                    // Create or updated modified posts
                    if post.modifiedDate == nil
                        || dateFormatter.dateFromString(item["modified"].string!)!
                            .compare(post.modifiedDate!) == .OrderedDescending {
                                post.title = item["title"].string
                                post.summary = item["excerpt"].string
                                post.content = item["content"].string
                                post.url = item["link"].string
                                post.type = item["type"].string
                                post.slug = item["slug"].string
                                post.status = item["status"].string
                                
                                if let value = item["date"].string {
                                    post.creationDate = dateFormatter.dateFromString(value)
                                    post.publicationDate = dateFormatter.dateFromString(value)
                                }
                                
                                if let value = item["modified"].string {
                                    post.modifiedDate = dateFormatter.dateFromString(value)
                                }
                                
                                let imageJson = item["featured_image"]
                                if imageJson.type != .Null {
                                    var image = ZamzamManager.sharedInstance.dataContext.images.firstOrCreated { $0.id == imageJson["ID"].int32 }
                                    image.title = imageJson["title"].string
                                    image.url = imageJson["guid"].string
                                    image.slug = imageJson["slug"].string
                                    
                                    if let width = imageJson["attachment_meta"]["width"].int32 {
                                        image.width = width
                                    }
                                    
                                    if let height = imageJson["attachment_meta"]["height"].int32 {
                                        image.height = height
                                    }
                                    
                                    let thumbnail = imageJson["attachment_meta"]["sizes"]["thumbnail"]
                                    if thumbnail.type != .Null {
                                        image.thumbnailUrl = thumbnail["url"].string
                                        
                                        if let width = thumbnail["width"].int32 {
                                            image.thumbnailWidth = width
                                        }
                                        
                                        if let height = thumbnail["height"].int32 {
                                            image.thumbnailHeight = height
                                        }
                                    }
                                    
                                    post.image = image
                                }
                                
                                let authorJson = item["author"]
                                if authorJson.type != .Null {
                                    var author = ZamzamManager.sharedInstance.dataContext.authors.firstOrCreated { $0.id == authorJson["ID"].int32 }
                                    author.username = authorJson["username"].string
                                    author.name = authorJson["name"].string
                                    author.avatar = authorJson["avatar"].string
                                    author.bio = authorJson["description"].string
                                    author.url = authorJson["URL"].string
                                    author.slug = authorJson["slug"].string
                                    
                                    if let value = authorJson["registered"].string {
                                        author.creationDate = dateFormatter.dateFromString(value)
                                        author.registrationDate = dateFormatter.dateFromString(value)
                                    }
                                    
                                    post.author = author
                                }
                                
                                if item["terms"]["category"].type != .Null {
                                    for (subKey: String, subJson: JSON) in item["terms"]["category"] {
                                        var term = ZamzamManager.sharedInstance.dataContext.terms.firstOrCreated { $0.id == subJson["ID"].int32 }
                                        term.title = subJson["name"].string
                                        term.content = subJson["description"].string
                                        term.url = subJson["link"].string
                                        term.slug = subJson["slug"].string
                                        term.taxonomy = subJson["taxonomy"].string
                                        
                                        if let count = subJson["count"].int32 {
                                            term.count = count
                                        }
                                        
                                        if subJson["parent"].type != .Null {
                                            term.parent = ZamzamManager.sharedInstance.dataContext.terms.firstOrCreated { item in
                                                item.id == subJson["parent"]["ID"].int32!
                                            }
                                        }
                                        
                                        post.terms.insert(term)
                                    }
                                }
                                
                                if item["terms"]["post_tag"].type != .Null {
                                    for (subKey: String, subJson: JSON) in item["terms"]["post_tag"] {
                                        var term = ZamzamManager.sharedInstance.dataContext.terms.firstOrCreated { $0.id == subJson["ID"].int32 }
                                        term.title = subJson["name"].string
                                        term.content = subJson["description"].string
                                        term.url = subJson["link"].string
                                        term.slug = subJson["slug"].string
                                        term.taxonomy = subJson["taxonomy"].string
                                        term.count = subJson["count"].int32!
                                        
                                        if subJson["parent"].type != .Null {
                                            term.parent = ZamzamManager.sharedInstance.dataContext.terms.firstOrCreated { item in
                                                item.id == subJson["parent"]["ID"].int32!
                                            }
                                        }
                                        
                                        post.terms.insert(term)
                                    }
                                }
                                
                                updateCount++
                    }
                }
            }
            
            if updateCount > 0 {
                ZamzamManager.sharedInstance.dataContext.save()
            }
        }
        
        return updateCount
    }
    
}