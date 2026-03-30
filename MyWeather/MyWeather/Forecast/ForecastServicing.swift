//
//  ForecastServicing.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import Foundation

protocol ForecastServicing {
    func fetchForecastData(latitude: Double, longitude: Double) async throws -> Result<ForecastResponse, NetworkError>
}

final class ForecastService: ForecastServicing {
    let container: DependencyContainer
    private let forecastBaseUrl = "https://api.openweathermap.org/data/2.5/forecast"
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func fetchForecastData(latitude: Double, longitude: Double) async throws -> Result<ForecastResponse, NetworkError> {
        guard let forecastUrl = URL(string: "\(forecastBaseUrl)?lat=\(latitude)&lon=\(longitude)&appid=\(AppSecrets.weatherApIKey)") else {
            return .failure(.invalidUrl)
        }
        do {
            let forecastResponse: ForecastResponse = try await container.appDependencies.network.fetchRequest(requestUrl: forecastUrl, type: ForecastResponse.self)
            return .success(forecastResponse)
        } catch {
            return .failure(error as! NetworkError)
        }
    }
}
