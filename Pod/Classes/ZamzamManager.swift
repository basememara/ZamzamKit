//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class ZamzamManager: NSObject {
    
    public var storageService: StorageService!
    public var fileService: FileService!
    public var communicationService: CommunicationService!
    public var locationService: LocationService!
    public var dateTimeService: DateTimeService!
    public var notificationService: NotificationService!
    public var alertService: AlertService!
    public var webService: WebService!
    public var animationService: AnimationService!
    
    public override init() {
        // Inject service dependencies
        storageService = StorageService()
        fileService = FileService()
        communicationService = CommunicationService()
        locationService = LocationService()
        dateTimeService = DateTimeService()
        notificationService = NotificationService()
        alertService = AlertService()
        webService = WebService()
        animationService = AnimationService()
    }
    
}
