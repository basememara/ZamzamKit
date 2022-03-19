//
//  File 2.swift
//  
//
//  Created by Basem Emara on 2020-06-15.
//

import CoreLocation

// MARK: - Service

public protocol LocationService: AnyObject {
    var delegate: LocationServiceDelegate? { get set }

    var isAuthorized: Bool { get }
    func isAuthorized(for type: LocationAPI.AuthorizationType) -> Bool

    var canRequestAuthorization: Bool { get }
    func requestAuthorization(for type: LocationAPI.AuthorizationType)

    var location: CLLocation? { get }
    func startUpdatingLocation(enableBackground: Bool, pauseAutomatically: Bool?)
    func stopUpdatingLocation()

    #if os(iOS)
    func startMonitoringSignificantLocationChanges()
    func stopMonitoringSignificantLocationChanges()
    #endif

    #if os(iOS) || os(watchOS)
    var heading: CLHeading? { get }
    var shouldDisplayHeadingCalibration: Bool { get set }
    func startUpdatingHeading() -> Bool
    func stopUpdatingHeading()
    #endif
}

// MARK: - Delegates

public protocol LocationServiceDelegate: AnyObject {
    func locationService(didChangeAuthorization authorization: Bool)
    func locationService(didUpdateLocation location: CLLocation)
    func locationService(didFailWithError error: CLError)

    #if os(iOS) || os(watchOS)
    func locationService(didUpdateHeading newHeading: CLHeading)
    #endif
}

// MARK: - Namespace

public enum LocationAPI {
    /// Permission types to use location services.
    ///
    /// - whenInUse: While the app is in the foreground.
    /// - always: Whenever the app is running.
    public enum AuthorizationType {
        case whenInUse, always
    }
}
