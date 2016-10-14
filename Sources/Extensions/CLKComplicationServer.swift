//
//  CLKComplicationServer.swift
//  ZamzamKit
//
//  Created by Basem Emara on 3/22/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import Foundation
import ClockKit

public extension CLKComplicationServer {
    
    /**
     Invalidates and reloads all timeline data
     */
    public func reloadTimelineForComplications() {
        if let complications = activeComplications, !complications.isEmpty {
            for complication in complications {
                reloadTimeline(for: complication)
            }
        }
    }
    
}
