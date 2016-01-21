//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class LocationService: NSObject {
  
    /**
     Calculates the distance between coordinates
     
     - parameter from: First [latitude, longitude] coordinates
     - parameter to: Second [latitude, longitude] coordinates
     
     - returns: Distance in kilometers
     */
    public func getDistanceBetweenCoordinates(from: [Double], _ to: [Double]) -> Double {
        let latitudeArc  = (from[0] - to[0]) * ZamzamConstants.Location.DEG_TO_RAD
        let longitudeArc = (from[1] - to[1]) * ZamzamConstants.Location.DEG_TO_RAD
        
        var latitudeH = sin(latitudeArc * 0.5)
        latitudeH *= latitudeH
        
        var lontitudeH = sin(longitudeArc * 0.5)
        lontitudeH *= lontitudeH
        
        let tmp = cos(from[0] * ZamzamConstants.Location.DEG_TO_RAD)
            * cos(to[0] * ZamzamConstants.Location.DEG_TO_RAD)
        
        return (ZamzamConstants.Location.EARTH_RADIUS_IN_METERS * 2.0
            * asin(sqrt(latitudeH + tmp * lontitudeH))) / 1000
    }
    
}
