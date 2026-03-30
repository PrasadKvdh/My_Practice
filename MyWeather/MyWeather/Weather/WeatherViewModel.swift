//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import SwiftUI
import Combine

enum WeatheUIStates {
    case idle
    case loading
    case success(WeatherResponse)
    case failure(String)
}

class WeatherViewModel: ObservableObject {
    var weatherService: WeatherServicing
    @Published var weatherUIState: WeatheUIStates = .idle
    
    init(geoResponse: GeoResponse, weatherService: WeatherServicing) {
        self.weatherService = weatherService
        Task {
            await loadWeatherData(response: geoResponse)
        }
    }
    
    func loadWeatherData(response: GeoResponse) async {
        weatherUIState = .loading
        do {
            async let weatherDataFetcher = weatherService.fetchWeatherData(latitude: response.lat, longitude: response.lon)
            
            let weatherResponse = try await weatherDataFetcher
            switch weatherResponse {
            case .success(let response):
                weatherUIState = .success(response)
            case .failure(let error):
                self.weatherUIState = .failure(error.localizedDescription)
            }
        } catch {
            self.weatherUIState = .failure(error.localizedDescription)
        }
    }
}
