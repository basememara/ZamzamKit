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
    var lastComplicationReload: Date? { get set }
}

public extension Complicationable {
    
    var complicationExpiryInterval: Int {
        return 60
    }
    
    func reloadComplications() {
        if lastComplicationReload?.hasElapsed(complicationExpiryInterval) ?? true {
            CLKComplicationServer.sharedInstance().reloadTimelineForComplications()
            lastComplicationReload = Date()
        }
    }
    
}
