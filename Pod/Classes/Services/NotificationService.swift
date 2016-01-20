//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class NotificationService: NSObject {
    
    public let dateTimeHelper: DateTimeHelper!
    
    override init() {
        // Inject service dependencies
        dateTimeHelper = DateTimeHelper()
    }
    
}
