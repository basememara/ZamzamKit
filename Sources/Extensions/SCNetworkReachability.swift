//
//  SCNetworkReachability.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/10/16.
//  Copyright © 2016 Zamzam. All rights reserved.
//

import SystemConfiguration

public extension SCNetworkReachability {

    /**
     Determines if device is connected to network
     http://stackoverflow.com/a/25623647/235334

     - returns: True if connected to network.
     */
    public static var isOnline: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else { return false }

        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
}