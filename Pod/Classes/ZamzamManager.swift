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
    public let configurationService: ConfigurationService!
    public let locationService: LocationService!
    public let dateTimeService: DateTimeService!
    public let notificationService: NotificationService!
    public let alertService: AlertService!
    public let webService: WebService!
    public let animationService: AnimationService!
    
    public override init() {
        // Inject service dependencies
        storageService = StorageService()
        fileService = FileService()
        communicationService = CommunicationService()
        configurationService = ConfigurationService()
        locationService = LocationService()
        dateTimeService = DateTimeService()
        notificationService = NotificationService()
        alertService = AlertService()
        webService = WebService()
        animationService = AnimationService()
    }
    
}
