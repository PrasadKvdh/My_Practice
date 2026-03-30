//
//  Forecast.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import Foundation
import Combine

enum forecastUIStates {
    case idle
    case loading
    case success
    case failure(String)
}

struct Day: Identifiable {
    var id: UUID = UUID()
    let date: Date
    let low: Int
    let high: Int
    let icon: String
}

class ForecastViewModel: ObservableObject {
    @Published var uiState: forecastUIStates = .idle
    @Published var forecastByDate: [Day] = []
    @Published var hourlyForecast: [DataList] = []
    @Published var fResponse: ForecastResponse?
    
    var service: ForecastService
    
    init(service: ForecastService, geo: GeoResponse) {
        self.service = service
        Task {
            await loadForecastData(geo: geo)
        }
    }
    
    func loadForecastData(geo: GeoResponse) async {
        do {
            async let forecastDataFetcher = service.fetchForecastData(latitude: geo.lat, longitude: geo.lon)
            
            let forecastResponse = try await forecastDataFetcher
            switch forecastResponse {
            case .success(let response):
                service.container.appDependencies.logger.info("[ForecastViewModel] - Forecast Data: \(response)")
                fResponse = response
                filterHourlyForecast(response: response)
                transformResponseToDays(response: response)
                uiState = .success
            case .failure(let error):
                service.container.appDependencies.logger.error("[ForecastViewModel] - Error at : \(error)")
                self.uiState = .failure(error.localizedDescription)
            }
        } catch {
            service.container.appDependencies.logger.error("[ForecastViewModel] - Error at catch: \(error)")
            self.uiState = .failure(error.localizedDescription)
        }
    }
    
    func filterHourlyForecast(response: ForecastResponse) {
        hourlyForecast = response.list.filter { Calendar.current.isDateInToday(Date(timeIntervalSince1970: Double($0.dt))) ||
            Calendar.current.isDateInTomorrow(Date(timeIntervalSince1970: Double($0.dt)))
        }
    }
    
    func transformResponseToDays(response: ForecastResponse) {
        let dataByDate = Dictionary(grouping: response.list) {
            Calendar.current.startOfDay(for: Date(timeIntervalSince1970: Double($0.dt)))
        }
        
        var daysArray:[Day] = []
        for key in dataByDate.keys {
            if key == Date(), let values = dataByDate[key] {
                let currentForecast: [DataList] = values.filter {
                    Date(timeIntervalSince1970: Double($0.dt)).timeIntervalSinceNow <= 10800
                }
                if let first = currentForecast.first, let weather = currentForecast.first?.weather.first {
                    let today = Day(date: key, low: Int(first.main.tempMin), high: Int(first.main.tempMax), icon: weather.icon)
                    daysArray.append(today)
                }
            } else if let values = dataByDate[key] {
                    let stats = values.reduce((minTemp: Double.infinity, maxTemp: 0.0)) { result, product in
                        (min(result.minTemp, product.main.tempMin), max(result.maxTemp, product.main.tempMax))
                }
                    
                if let firstHour = values.first, let weather = firstHour.weather.first {
                        let nextDay = Day(date: key, low: Int(stats.minTemp), high: Int(stats.maxTemp), icon: weather.icon)
                     daysArray.append(nextDay)
                }
            }
        }
        
        forecastByDate = daysArray.sorted(by: { $0.date < $1.date })
    }
}


