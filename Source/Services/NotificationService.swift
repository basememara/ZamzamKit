//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public struct NotificationService {
    
    public let dateTimeHelper: DateTimeHelper!
    
    init() {
        // Inject service dependencies
        dateTimeHelper = DateTimeHelper()
    }
    
}
