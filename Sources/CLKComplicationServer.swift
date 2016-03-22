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
    
    public func reloadTimelineForComplications() {
        if let complications = self.activeComplications
            where complications.any() {
                for complication in complications {
                    self.reloadTimelineForComplication(complication)
                }
        }
    }
    
}