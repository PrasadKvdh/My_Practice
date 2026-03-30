//
//  WeatherService.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//
import Foundation

protocol WeatherServicing {
    func fetchWeatherData(latitude: Double, longitude: Double) async throws -> Result<WeatherResponse, NetworkError>
}

final class WeatherService: WeatherServicing {
    let container: DependencyContainer
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) async throws -> Result<WeatherResponse, NetworkError>  {
        guard let weatherUrl = URL(string: "\(baseUrl)weather?lat=\(latitude)&lon=\(longitude)&appid=\(AppSecrets.weatherApIKey)") else {
            return .failure(.invalidUrl)
        }
        do {
            let weatherResponse: WeatherResponse = try await container.appDependencies.network.fetchRequest(requestUrl: weatherUrl, type: WeatherResponse.self)
            return .success(weatherResponse)
        } catch {
            return .failure(error as! NetworkError)
        }
    }
}
