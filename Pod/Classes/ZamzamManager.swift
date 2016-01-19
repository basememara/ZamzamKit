//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class ZamzamManager: NSObject {
    
    public let storageService: StorageService!
    public let fileService: FileService!
    public let communicationService: CommunicationService!
    public let locationService: LocationService!
    public let notificationService: NotificationService!
    
    public override init() {
        // Inject service dependencies
        storageService = StorageService()
        fileService = FileService()
        communicationService = CommunicationService()
        locationService = LocationService()
        notificationService = NotificationService()
    }
    
}
