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
    func reloadTimelineForComplications() {
        guard let complications = activeComplications, !complications.isEmpty else { return }
        complications.forEach { reloadTimeline(for: $0) }
    }
    
}
