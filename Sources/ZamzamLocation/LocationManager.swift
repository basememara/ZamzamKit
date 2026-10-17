//
//  LocationManager.swift
//  ZamzamLocation
//
//  Created by Basem Emara on 2020-05-30.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import CoreLocation
import ZamzamCore

/// Location services as async calls: permission, one fix, and headings.
@MainActor
public final class LocationManager: NSObject {
    private let manager: CLLocationManager
    private var authorizationWaiters: [CheckedContinuation<Void, Never>] = []
    private var authorizationTimeout: Task<Void, Never>?

    #if os(iOS) || os(watchOS)
    private var headingContinuation: AsyncStream<Result<Heading, CLError>>.Continuation?
    private var headingStream = 0
    private var shouldDisplayHeadingCalibration = false
    #endif

    /// - Parameters:
    ///   - desiredAccuracy: The accuracy of the location updates that run beside headings so they resolve
    ///     true north; one-off fixes come from `CLLocationUpdate`, which sets its own.
    ///   - distanceFilter: The distance before one of those location updates is taken.
    public init(desiredAccuracy: CLLocationAccuracy? = nil, distanceFilter: CLLocationDistance? = nil) {
        manager = CLLocationManager().apply {
            $0.desiredAccuracy ?= desiredAccuracy
            $0.distanceFilter ?= distanceFilter
        }

        super.init()
        manager.delegate = self
    }
}

/// Why a location could not be found.
public enum LocationError: Error, Equatable, Sendable {
    /// The user denied location access, or location services are off for the device.
    case denied
    /// No fix arrived and the device holds no last known location.
    case unavailable
}

// MARK: - Authorization

public extension LocationManager {
    /// Whether location services are authorized always or when in use.
    var isAuthorized: Bool { manager.isAuthorized }

    /// Whether the user hasn't decided yet whether the app may use location services.
    var canRequestAuthorization: Bool { manager.authorizationStatus == .notDetermined }

    #if !os(watchOS)
    /// Whether a widget is eligible to receive location updates.
    var isAuthorizedForWidgetUpdates: Bool { manager.isAuthorizedForWidgetUpdates }
    #endif

    /// Asks for when-in-use permission if the user hasn't decided, and returns once they answer.
    ///
    /// A prompt asked for while the app is in the background never appears, so the wait gives up after `timeout`.
    ///
    /// - Returns: Whether location services are authorized.
    func requestAuthorization(timeout: Duration = .seconds(60)) async -> Bool {
        guard canRequestAuthorization else { return isAuthorized }

        // The first caller asks and starts the clock; later callers wait on the same prompt
        if authorizationWaiters.isEmpty {
            manager.requestWhenInUseAuthorization()

            authorizationTimeout = Task { [weak self] in
                guard (try? await Task.sleep(for: timeout)) != nil else { return }
                self?.resumeAuthorizationWaiters()
            }
        }

        await withCheckedContinuation { authorizationWaiters.append($0) }
        return isAuthorized
    }
}

// MARK: - Location

public extension LocationManager {
    /// The most recently retrieved location.
    var location: CLLocation? { manager.location }

    /// One location, asking for permission first if the user hasn't decided.
    ///
    /// Waits for a fix no older than `maximumAge`; Core Location may replay an older one first. After `timeout`
    /// without one, the last known location stands in, so no signal never holds the call open.
    func currentLocation(maximumAge: TimeInterval = 5, timeout: Duration = .seconds(30)) async -> Result<CLLocation, LocationError> {
        guard await requestAuthorization() else { return .failure(.denied) }

        let oldest = Date.now - maximumAge

        let fresh = await withTaskGroup(of: CLLocation?.self) { group in
            group.addTask {
                try? await CLLocationUpdate.liveUpdates()
                    .first { ($0.location?.timestamp ?? .distantPast) >= oldest }?
                    .location
            }

            group.addTask {
                try? await Task.sleep(for: timeout)
                return nil
            }

            let first = await group.next() ?? nil
            group.cancelAll()
            return first
        }

        guard let location = fresh ?? location else { return .failure(isAuthorized ? .unavailable : .denied) }
        return .success(location)
    }
}

// MARK: - Heading

#if os(iOS) || os(watchOS)
public extension LocationManager {
    /// A compass reading, copied out of Core Location's `CLHeading` so it can cross actors.
    struct Heading: Equatable, Sendable {
        /// Degrees from magnetic north.
        public let magneticHeading: CLLocationDirection

        /// Degrees from true north; negative when it can't be determined.
        public let trueHeading: CLLocationDirection

        /// The most the magnetic heading may be off, in degrees; negative when it's unreliable.
        public let headingAccuracy: CLLocationDirectionAccuracy

        public init(magneticHeading: CLLocationDirection, trueHeading: CLLocationDirection, headingAccuracy: CLLocationDirectionAccuracy) {
            self.magneticHeading = magneticHeading
            self.trueHeading = trueHeading
            self.headingAccuracy = headingAccuracy
        }
    }

    /// Headings until the stream is cancelled, the latest one first when the consumer falls behind, with each
    /// compass failure in between, such as magnetic interference.
    ///
    /// Ends at once on a device with no compass. Starting a new stream ends the previous one.
    func headings(allowCalibration: Bool = false) -> AsyncStream<Result<Heading, CLError>> {
        AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            headingContinuation?.finish()

            guard CLLocationManager.headingAvailable() else {
                continuation.yield(.failure(CLError(.headingFailure)))
                continuation.finish()
                return
            }

            headingStream += 1
            let stream = headingStream
            headingContinuation = continuation
            shouldDisplayHeadingCalibration = allowCalibration
            manager.startUpdatingHeading()

            // True north is valid only while this manager also has location updates running
            if isAuthorized {
                manager.startUpdatingLocation()
            }

            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in self?.stopUpdatingHeading(stream) }
            }
        }
    }
}

private extension LocationManager {
    /// Stops the stream's updates, unless a newer stream has taken over since it ended.
    func stopUpdatingHeading(_ stream: Int) {
        guard stream == headingStream else { return }

        headingContinuation = nil
        shouldDisplayHeadingCalibration = false
        manager.stopUpdatingHeading()
        manager.stopUpdatingLocation()
    }
}
#endif

private extension LocationManager {
    func resumeAuthorizationWaiters() {
        authorizationTimeout?.cancel()
        authorizationTimeout = nil

        let waiters = authorizationWaiters
        authorizationWaiters = []
        waiters.forEach { $0.resume() }
    }
}

// MARK: - Delegates

// Core Location calls the delegate on the thread that created the manager, which is the main actor here
extension LocationManager: @preconcurrency CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus != .notDetermined else { return }
        resumeAuthorizationWaiters()
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if os(iOS) || os(watchOS)
        // The location updates that run beside headings fail on their own; only a compass failure is the stream's
        guard let error = error as? CLError, error.code == .headingFailure else { return }
        headingContinuation?.yield(.failure(error))
        #endif
    }

    #if os(iOS) || os(watchOS)
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingContinuation?.yield(
            .success(
                Heading(
                    magneticHeading: newHeading.magneticHeading,
                    trueHeading: newHeading.trueHeading,
                    headingAccuracy: newHeading.headingAccuracy
                )
            )
        )
    }

    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        shouldDisplayHeadingCalibration
    }
    #endif
}
