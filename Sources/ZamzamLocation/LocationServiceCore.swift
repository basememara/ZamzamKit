//
//  LocationServiceCore.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 2019-08-25.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import CoreLocation
import ZamzamCore

public class LocationServiceCore: NSObject, LocationService {
    private let desiredAccuracy: CLLocationAccuracy?
    private let distanceFilter: Double?
    private let activityType: CLActivityType?

    public weak var delegate: LocationServiceDelegate?
    public var shouldDisplayHeadingCalibration = false

    /// Internal Core Location manager
    private lazy var manager = CLLocationManager().apply {
        $0.desiredAccuracy ?= self.desiredAccuracy
        $0.distanceFilter ?= self.distanceFilter

        #if os(iOS)
        $0.activityType ?= self.activityType
        #endif
    }

    public required init(
        desiredAccuracy: CLLocationAccuracy? = nil,
        distanceFilter: Double? = nil,
        activityType: CLActivityType? = nil
    ) {
        self.desiredAccuracy = desiredAccuracy
        self.distanceFilter = distanceFilter
        self.activityType = activityType

        super.init()
        manager.delegate = self
    }
}

// MARK: - Authorization

public extension LocationServiceCore {
    var isAuthorized: Bool { manager.isAuthorized }

    #if !os(watchOS) && !os(tvOS)
    var isAuthorizedForWidgetUpdates: Bool { manager.isAuthorizedForWidgetUpdates }
    #endif

    var canRequestAuthorization: Bool { manager.authorizationStatus == .notDetermined }

    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
}

// MARK: - Coordinate

public extension LocationServiceCore {
    var location: CLLocation? { manager.location }

    func startUpdatingLocation(enableBackground: Bool, pauseAutomatically: Bool?) {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = enableBackground
        manager.pausesLocationUpdatesAutomatically ?= pauseAutomatically
        #endif

        #if !os(tvOS)
        manager.startUpdatingLocation()
        #endif
    }

    func stopUpdatingLocation() {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = false
        manager.pausesLocationUpdatesAutomatically = true
        #endif

        manager.stopUpdatingLocation()
    }
}

#if os(iOS)
public extension LocationServiceCore {
    func startMonitoringSignificantLocationChanges() {
        manager.startMonitoringSignificantLocationChanges()
    }

    func stopMonitoringSignificantLocationChanges() {
        manager.stopMonitoringSignificantLocationChanges()
    }
}
#endif

// MARK: - Heading

#if os(iOS) || os(watchOS)
public extension LocationServiceCore {
    var heading: CLHeading? { manager.heading }

    func startUpdatingHeading() -> Bool {
        guard CLLocationManager.headingAvailable() else { return false }
        manager.startUpdatingHeading()
        return true
    }

    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        delegate?.locationService(didUpdateHeading: newHeading)
    }

    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        shouldDisplayHeadingCalibration
    }
}
#endif

// MARK: - Delegates

extension LocationServiceCore: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus != .notDetermined else { return }

        DispatchQueue.transform.async {
            // The `locationServicesEnabled` request cannot be called on main thread
            let isAuthorized = self.isAuthorized
            DispatchQueue.main.async { self.delegate?.locationService(didChangeAuthorization: isAuthorized) }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.locationService(didUpdateLocation: location)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else { return }
        delegate?.locationService(didFailWithError: error)
    }
}
