//
//  LocationManager.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 2020-05-30.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import Combine
import CoreLocation.CLError
import CoreLocation.CLHeading
import CoreLocation.CLLocation

/// A `LocationManager` proxy with publisher.
public class LocationManager {
    private let service: LocationService

    public init(service: LocationService) {
        self.service = service
        self.service.delegate = self
    }
}

// MARK: - Authorization

public extension LocationManager {
    /// Determines if location services is enabled and authorized for always or when in use.
    var isAuthorized: Bool { service.isAuthorized }

    /// Determines if location services is enabled and authorized for the specified authorization type.
    func isAuthorized(for type: LocationAPI.AuthorizationType) -> Bool {
        service.isAuthorized(for: type)
    }

    /// Requests permission to use location services.
    ///
    /// - Parameters:
    ///   - type: Type of permission required, whether in the foreground (.whenInUse) or while running (.always).
    ///   - startUpdatingLocation: Starts the generation of updates that report the user’s current location.
    ///   - completion: True if the authorization succeeded for the authorization type, false otherwise.
    @discardableResult
    func requestAuthorization(for type: LocationAPI.AuthorizationType = .whenInUse) -> AnyPublisher<Bool, Never> {
        // Handle authorized and exit
        guard !isAuthorized(for: type) else {
            Self.authorizationSubject.send(true)
            return publisher()
        }

        // Request appropiate authorization before exit
        defer { service.requestAuthorization(for: type) }

        // Handle mismatched allowed and exit
        guard !isAuthorized else {
            // Notify in case authorization dialog not launched by OS
            // since user will be notified first time only and ignored subsequently
            Self.authorizationSubject.send(false)
            return publisher()
        }

        // Handle denied and exit
        guard service.canRequestAuthorization else {
            Self.authorizationSubject.send(false)
            return publisher()
        }

        return publisher()
    }
}

// MARK: - Coordinate

public extension LocationManager {
    /// The most recently retrieved user location.
    var location: CLLocation? { service.location }

    /// Starts the generation of updates that report the user’s current location.
    @discardableResult
    func startUpdatingLocation(
        enableBackground: Bool = false,
        pauseAutomatically: Bool? = nil
    ) -> AnyPublisher<CLLocation, CLError> {
        service.startUpdatingLocation(
            enableBackground: enableBackground,
            pauseAutomatically: pauseAutomatically
        )

        return publisher()
    }

    /// Stops the generation of location updates.
    func stopUpdatingLocation() {
        service.stopUpdatingLocation()
    }
}

#if os(iOS)
public extension LocationManager {
    /// Starts the generation of updates based on significant location changes.
    @discardableResult
    func startMonitoringSignificantLocationChanges() -> AnyPublisher<CLLocation, CLError> {
        service.startMonitoringSignificantLocationChanges()
        return publisher()
    }

    /// Stops the delivery of location events based on significant location changes.
    func stopMonitoringSignificantLocationChanges() {
        service.stopMonitoringSignificantLocationChanges()
    }
}
#endif

// MARK: - Heading

#if os(iOS)
public extension LocationManager {
    /// The most recently reported heading.
    var heading: CLHeading? { service.heading }

    /// Starts the generation of updates that report the user’s current heading.
    @discardableResult
    func startUpdatingHeading() -> AnyPublisher<CLHeading, CLError> {
        service.startUpdatingHeading()
        return publisher()
    }

    /// Stops the generation of heading updates.
    func stopUpdatingHeading() {
        service.stopUpdatingHeading()
    }

    func locationService(didUpdateHeading newHeading: CLHeading) {
        Self.headingSubject.send(newHeading)
    }
}
#endif

// MARK: - Delegates

extension LocationManager: LocationServiceDelegate {
    public func locationService(didChangeAuthorization authorization: Bool) {
        Self.authorizationSubject.send(authorization)
    }

    public func locationService(didUpdateLocation location: CLLocation) {
        Self.locationSubject.send(location)
    }

    public func locationService(didFailWithError error: CLError) {
        Self.locationSubject.send(completion: .failure(error))

        #if os(iOS)
        Self.headingSubject.send(completion: .failure(error))
        #endif
    }
}

// MARK: - Observables

public extension LocationManager {
    private static let authorizationSubject = CurrentValueSubject<Bool?, Never>(nil)
    private static let locationSubject = CurrentValueSubject<CLLocation?, CLError>(nil)
    #if os(iOS)
    private static let headingSubject = CurrentValueSubject<CLHeading?, CLError>(nil)
    #endif

    func publisher() -> AnyPublisher<Bool, Never> {
        Self.authorizationSubject
            .compactMap { $0 }
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func publisher() -> AnyPublisher<CLLocation, CLError> {
        Self.locationSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    #if os(iOS)
    func publisher() -> AnyPublisher<CLHeading, CLError> {
        Self.headingSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    #endif
}
