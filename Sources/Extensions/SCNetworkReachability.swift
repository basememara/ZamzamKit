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
    static var isOnline: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
