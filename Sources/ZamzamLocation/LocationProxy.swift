//
//  LocationProxy.swift
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
@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public class LocationProxy {
    private let service: LocationService
    
    private static let authorizationSubject = CurrentValueSubject<Bool?, Never>(nil)
    public let authorizationPublisher = LocationProxy.authorizationSubject.compactMap { $0 }.eraseToAnyPublisher()
    
    private static let locationSubject = CurrentValueSubject<CLLocation?, CLError>(nil)
    public var locationPublisher = LocationProxy.locationSubject.compactMap { $0 }.eraseToAnyPublisher()
    
    #if os(iOS)
    private static let headingSubject = CurrentValueSubject<CLHeading?, CLError>(nil)
    public var headingPublisher = LocationProxy.headingSubject.compactMap { $0 }.eraseToAnyPublisher()
    #endif
    
    public init(service: LocationService) {
        self.service = service
        self.service.delegate = self
    }
}

// MARK: - Authorization

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension LocationProxy {
    var isAuthorized: Bool { service.isAuthorized }
    
    func isAuthorized(for type: LocationAPI.AuthorizationType) -> Bool {
        service.isAuthorized(for: type)
    }
    
    @discardableResult
    func requestAuthorization(for type: LocationAPI.AuthorizationType = .whenInUse) -> AnyPublisher<Bool, Never> {
        // Handle authorized and exit
        guard !isAuthorized(for: type) else {
            Self.authorizationSubject.send(true)
            return authorizationPublisher
        }
        
        // Request appropiate authorization before exit
        defer { service.requestAuthorization(for: type) }
        
        // Handle mismatched allowed and exit
        guard !isAuthorized else {
            // Notify in case authorization dialog not launched by OS
            // since user will be notified first time only and ignored subsequently
            Self.authorizationSubject.send(false)
            return authorizationPublisher
        }
        
        // Handle denied and exit
        guard service.canRequestAuthorization else {
            Self.authorizationSubject.send(false)
            return authorizationPublisher
        }
        
        return authorizationPublisher
    }
}

// MARK: - Coordinate

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension LocationProxy {
    var location: CLLocation? { service.location }
    
    @discardableResult
    func startUpdatingLocation(enableBackground: Bool = false) -> AnyPublisher<CLLocation, CLError> {
        service.startUpdatingLocation(enableBackground: enableBackground)
        return locationPublisher
    }
    
    func stopUpdatingLocation() {
        service.stopUpdatingLocation()
    }
}

#if os(iOS)
@available(iOS 13, *)
public extension LocationProxy {
    
    @discardableResult
    func startMonitoringSignificantLocationChanges() -> AnyPublisher<CLLocation, CLError> {
        service.startMonitoringSignificantLocationChanges()
        return locationPublisher
    }
    
    func stopMonitoringSignificantLocationChanges() {
        service.stopMonitoringSignificantLocationChanges()
    }
}
#endif

// MARK: - Heading

#if os(iOS)
@available(iOS 13, *)
public extension LocationProxy {
    var heading: CLHeading? { service.heading }
    
    @discardableResult
    func startUpdatingHeading() -> AnyPublisher<CLHeading, CLError> {
        service.startUpdatingHeading()
        return headingPublisher
    }
    
    func stopUpdatingHeading() {
        service.stopUpdatingHeading()
    }
    
    func locationService(didUpdateHeading newHeading: CLHeading) {
        Self.headingSubject.send(newHeading)
    }
}
#endif

// MARK: - Delegates

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension LocationProxy: LocationServiceDelegate {
    
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
