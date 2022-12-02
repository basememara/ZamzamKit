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
    #if !os(watchOS) && !os(tvOS)
    var isAuthorizedForWidgetUpdates: Bool { get }
    #endif

    var canRequestAuthorization: Bool { get }
    func requestAuthorization()

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
