//
//  SearchGeoService.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//
import Foundation

protocol SearchGeoServicing {
    func fetchGeoData(searchString: String) async throws -> Result<GeoResponse, NetworkError>
}

final class SearchGeoService: SearchGeoServicing {
    let container: DependencyContainer
    private let geoBaseUrl = "https://api.openweathermap.org/geo/1.0/direct"
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func fetchGeoData(searchString: String) async throws -> Result<GeoResponse, NetworkError> {
        guard let userUrl = URL(string: "\(geoBaseUrl)?q=\(searchString)&appid=\(AppSecrets.weatherApIKey)") else {
            return .failure(.invalidUrl)
        }
         do {
             let geoResponse = try await container.appDependencies.network.fetchRequest(requestUrl: userUrl, type: [GeoResponse].self)
             guard let first = geoResponse.first else { return .failure(.badResponse) }
             return .success(first)
         } catch let error as NetworkError {
             return .failure(error)
         }
    }
}

