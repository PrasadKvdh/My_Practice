//
//  LocationService.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/20/26.
//

import Foundation
import CoreLocation

enum LocationError: LocalizedError {
    case notAuthorized
    case locationUnavilable
    case unknown(Error)
}

protocol LocationServiceProtocol {
    var isAuthrorized: Bool { get }
    func requestPermission() async -> Bool
    func getCurrentCoordination() async throws -> (lat: Double, lon: Double)
}

final class LocationService: NSObject, LocationServiceProtocol {
    private let manager = CLLocationManager()
    private var coordinateContinution: CheckedContinuation<(lat: Double, lon: Double), Error>?
    private var permissionContinuation: CheckedContinuation<Bool, Never>?
    
     override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var isAuthrorized: Bool {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: return true
        default: return false
        }
    }
    
    func requestPermission() async -> Bool {
        if isAuthrorized { return true }
        return await withCheckedContinuation { cont in
            permissionContinuation = cont
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func getCurrentCoordination() async throws -> (lat: Double, lon: Double) {
        if !isAuthrorized { throw LocationError.notAuthorized }
        return try await withCheckedThrowingContinuation { cont in
            coordinateContinution = cont
            manager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        coordinateContinution?.resume(returning: (lat: loc.coordinate.latitude, lon: loc.coordinate.longitude))
        coordinateContinution = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        coordinateContinution?.resume(throwing: LocationError.unknown(error))
        coordinateContinution = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionContinuation?.resume(returning: isAuthrorized)
        permissionContinuation = nil
    }
}
