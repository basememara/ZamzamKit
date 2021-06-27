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

    /// Determines if the user has not chosen whether the app can use location services.
    var canRequestAuthorization: Bool { service.canRequestAuthorization }

    /// Requests permission to use location services.
    ///
    /// - Parameters:
    ///   - type: Type of permission required, whether in the foreground (.whenInUse) or while running (.always).
    ///   - startUpdatingLocation: Starts the generation of updates that report the user’s current location.
    ///   - completion: True if the authorization succeeded for the authorization type, false otherwise.
    func requestAuthorization(for type: LocationAPI.AuthorizationType = .whenInUse) -> AnyPublisher<Bool, Never> {
        let publisher = Self.authorizationSubject
            .compactMap { $0 }
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

        // Handle authorized and exit
        guard !isAuthorized(for: type) else {
            Self.authorizationSubject.send(true)
            return publisher
        }

        // Request appropiate authorization before exit
        defer { service.requestAuthorization(for: type) }

        // Handle mismatched allowed and exit
        guard !isAuthorized else {
            // Notify in case authorization dialog not launched by OS
            // since user will be notified first time only and ignored subsequently
            Self.authorizationSubject.send(false)
            return publisher
        }

        // Handle denied and exit
        guard service.canRequestAuthorization else {
            Self.authorizationSubject.send(false)
            return publisher
        }

        return publisher
    }
}

// MARK: - Coordinate

public extension LocationManager {
    /// The most recently retrieved user location.
    var location: CLLocation? { service.location }

    /// Starts the generation of updates that report the user’s current location.
    func startUpdatingLocation(
        enableBackground: Bool = false,
        pauseAutomatically: Bool? = nil
    ) -> AnyPublisher<Result<CLLocation, CLError>, Never> {
        service.startUpdatingLocation(
            enableBackground: enableBackground,
            pauseAutomatically: pauseAutomatically
        )

        return Self.locationSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    /// Stops the generation of location updates.
    func stopUpdatingLocation() {
        service.stopUpdatingLocation()
    }
}

#if os(iOS)
public extension LocationManager {
    /// Starts the generation of updates based on significant location changes.
    func startMonitoringSignificantLocationChanges() -> AnyPublisher<Result<CLLocation, CLError>, Never> {
        service.startMonitoringSignificantLocationChanges()

        return Self.locationSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
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
    func startUpdatingHeading(allowCalibration: Bool = false) -> AnyPublisher<Result<CLHeading, CLError>, Never> {
        service.shouldDisplayHeadingCalibration = allowCalibration

        if !service.startUpdatingHeading() {
            Self.headingSubject.send(.failure(CLError(.headingFailure)))
        }

        return Self.headingSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    /// Stops the generation of heading updates.
    func stopUpdatingHeading() {
        service.shouldDisplayHeadingCalibration = false
        service.stopUpdatingHeading()
    }

    func locationService(didUpdateHeading newHeading: CLHeading) {
        Self.headingSubject.send(.success(newHeading))
    }
}
#endif

// MARK: - Delegates

extension LocationManager: LocationServiceDelegate {
    public func locationService(didChangeAuthorization authorization: Bool) {
        Self.authorizationSubject.send(authorization)
    }

    public func locationService(didUpdateLocation location: CLLocation) {
        Self.locationSubject.send(.success(location))
    }

    public func locationService(didFailWithError error: CLError) {
        Self.locationSubject.send(.failure(error))

        #if os(iOS)
        Self.headingSubject.send(.failure(error))
        #endif
    }
}

// MARK: - Observables

private extension LocationManager {
    static let authorizationSubject = CurrentValueSubject<Bool?, Never>(nil)
    static let locationSubject = CurrentValueSubject<Result<CLLocation, CLError>?, Never>(nil)
    #if os(iOS)
    static let headingSubject = CurrentValueSubject<Result<CLHeading, CLError>?, Never>(nil)
    #endif
}
