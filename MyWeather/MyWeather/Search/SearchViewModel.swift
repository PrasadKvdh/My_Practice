//
//  SearchViewModel.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import Foundation
import Combine
import MetricKit

enum SearchViewState {
    case idle
    case loading
    case success
    case failure(String)
}

final class SearchViewModel: ObservableObject {
    var searchGeoService: SearchGeoServicing
    var wCoordinator: WeatherFlowCoordinator
    
    @Published var state: SearchViewState = .idle
    @Published var geoResponses: [GeoResponse] = []
    
    init(searchGeoService: SearchGeoServicing, weatherCoordinator: WeatherFlowCoordinator) {
        self.searchGeoService = searchGeoService
        self.wCoordinator = weatherCoordinator
        checkForCurrentLocation()
    }
    
    func searchGeo(searchString: String) async {
        do {
           let results = try await searchGeoService.fetchGeoData(searchString: searchString)
            switch results {
            case .success(let response):
                geoResponses.append(response)
                self.state = .success
            case .failure(let error):
                self.state = .failure(error.localizedDescription)
            }
        } catch {
            self.state = .failure(error.localizedDescription)
        }
    }
    
    func navigateToWeatherDetails(selectedGeo: GeoResponse) {
        wCoordinator.showWeatherDetails(geoResponse: selectedGeo)
    }
    
    func checkForCurrentLocation() {
        let locationService = LocationService()
        let poiLog = OSLog(subsystem: "com.apple", category: .pointsOfInterest
        )
        os_signpost(.begin, log: poiLog, name: "Testing ")
        Task { @MainActor in
            let granted = await locationService.requestPermission()
            if granted {
                do {
                    let (lat, lon) = try await locationService.getCurrentCoordination()
                    let response = GeoResponse(id: UUID(), name: "Current Location", lat: lat, lon: lon, country: "US", state: "")
                    geoResponses.insert(response, at: 0)
                    self.state = .success
                } catch {
                    print("Error getting location: \(error)")
                }
            } else {
                print("Location access was denied. You can search by city instead.")
            }
        }
        os_signpost(.end, log: poiLog, name: "Testing ")
    }
}

