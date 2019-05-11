//
//  SCNetworkReachability.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/10/16.
//  Copyright © 2016 Zamzam Inc. All rights reserved.
//

#if canImport(SystemConfiguration)
import SystemConfiguration

public extension SCNetworkReachability {

    /// Determines if the device is connected to the network.
    ///
    /// A remote host is considered reachable when a data packet, sent by
    /// an application into the network stack, can leave the local device.
    /// Reachability does not guarantee that the data packet will actually
    /// be received by the host.
    static var isOnline: Bool {
        // http://stackoverflow.com/a/25623647
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(
            to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
        }

        var flags: SCNetworkReachabilityFlags = []
        
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return isReachable && !needsConnection
    }
}
#endif
