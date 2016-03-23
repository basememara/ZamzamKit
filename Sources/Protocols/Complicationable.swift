//
//  Complicationable.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/18/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import WatchKit
import ClockKit

public protocol Complicationable: class {
    var lastComplicationReload: NSDate? { get set }
}

@available(watchOS 2, *)
public extension Complicationable {
    
    var complicationExpiryInterval: Int {
        return 60
    }
    
    func reloadComplications() {
        if let server = CLKComplicationServer.sharedInstance()
            where lastComplicationReload?.hasElapsed(complicationExpiryInterval) ?? true {
                server.reloadTimelineForComplications()
                lastComplicationReload = NSDate()
        }
    }
    
}