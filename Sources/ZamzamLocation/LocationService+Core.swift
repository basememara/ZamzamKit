//
//  CoreLocationService.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 2019-08-25.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import CoreLocation
import ZamzamCore

public class CoreLocationService: NSObject, LocationService {
    private let desiredAccuracy: CLLocationAccuracy?
    private let distanceFilter: Double?
    private let activityType: CLActivityType?

    public weak var delegate: LocationServiceDelegate?

    /// Internal Core Location manager
    private lazy var manager = CLLocationManager().apply {
        $0.delegate = self

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
    }
}

// MARK: - Authorization

public extension CoreLocationService {
    var isAuthorized: Bool { CLLocationManager.isAuthorized }

    func isAuthorized(for type: LocationAPI.AuthorizationType) -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }

        #if os(macOS)
        return type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways
        #else
        return (type == .whenInUse && CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
            || (type == .always && CLLocationManager.authorizationStatus() == .authorizedAlways)
        #endif
    }

    var canRequestAuthorization: Bool {
        CLLocationManager.authorizationStatus() == .notDetermined
    }

    func requestAuthorization(for type: LocationAPI.AuthorizationType) {
        #if os(macOS)
        if #available(OSX 10.15, *) {
            manager.requestAlwaysAuthorization()
        }
        #elseif os(tvOS)
        manager.requestWhenInUseAuthorization()
        #else
        switch type {
        case .whenInUse:
            manager.requestWhenInUseAuthorization()
        case .always:
            manager.requestAlwaysAuthorization()
        }
        #endif
    }
}

// MARK: - Coordinate

public extension CoreLocationService {
    var location: CLLocation? { manager.location }

    func startUpdatingLocation(enableBackground: Bool) {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = enableBackground
        #endif

        #if !os(tvOS)
        manager.startUpdatingLocation()
        #endif
    }

    func stopUpdatingLocation() {
        #if os(iOS)
        manager.allowsBackgroundLocationUpdates = false
        #endif

        manager.stopUpdatingLocation()
    }
}

#if os(iOS)
public extension CoreLocationService {

    func startMonitoringSignificantLocationChanges() {
        manager.startMonitoringSignificantLocationChanges()
    }

    func stopMonitoringSignificantLocationChanges() {
        manager.stopMonitoringSignificantLocationChanges()
    }
}

// MARK: - Heading

public extension CoreLocationService {
    var heading: CLHeading? { manager.heading }

    func startUpdatingHeading() {
        manager.startUpdatingHeading()
    }

    func stopUpdatingHeading() {
        manager.stopUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        delegate?.locationService(didUpdateHeading: newHeading)
    }
}
#endif

// MARK: - Delegates

extension CoreLocationService: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        delegate?.locationService(didChangeAuthorization: isAuthorized)
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
