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
    
    /// Invalidates and reloads all timeline data for all complications.
    func reloadTimelineForComplications() {
        guard let complications = activeComplications, !complications.isEmpty else { return }
        complications.forEach { reloadTimeline(for: $0) }
    }
    
    /// Extends all timeline data for all complications.
    func extendTimelineForComplications() {
        guard let complications = activeComplications, !complications.isEmpty else { return }
        complications.forEach { extendTimeline(for: $0) }
    }
    
}
