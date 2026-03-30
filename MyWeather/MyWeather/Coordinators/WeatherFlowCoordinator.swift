//
//  WeatherFlowCordinator.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/14/26.
//

import Foundation
import SwiftUI
import UIKit


final class WeatherFlowCoordinator {
    var container: DependencyContainer
    private var rootViewController: UINavigationController?
    var loginVC = UIViewController()
   
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func start() -> UIViewController {
        // Show WeatherView Flow
        let resultsVC = showWeatherFlow()
        let navController = UINavigationController(rootViewController: resultsVC)
        navController.navigationBar.prefersLargeTitles = true
        self.rootViewController = navController
        container.appDependencies.logger.debug("Weather flow root view launched")
        return navController
    }
    
    @MainActor
    func showWeatherFlow() -> UIViewController {
        let vc = UIHostingController(rootView: SearchView(vm: makeViewModel()))
        vc.title = "Weather"
        return vc
    }
    
    func showWeatherDetails(geoResponse: GeoResponse) {
        let weatherVC = WeatherView(viewModel: makeWeatheViewModel(geoResponse: geoResponse), forecastVM: makeForecastViewModel(geoResponse: geoResponse))
        let weather = UIHostingController(rootView: weatherVC)
        container.appDependencies.logger.debug("Pushing Weather details view")
        self.rootViewController?.pushViewController(weather, animated: true)
    }
    
    func makeViewModel() -> SearchViewModel {
        let searchService = SearchGeoService(container: container)
        let vm = SearchViewModel(searchGeoService: searchService, weatherCoordinator: self)
        container.appDependencies.logger.debug("SearchVM Initiated")
        return vm
    }
    
    func makeWeatheViewModel(geoResponse: GeoResponse) -> WeatherViewModel {
        let weatherService = WeatherService(container: container)
        let vm = WeatherViewModel(geoResponse: geoResponse, weatherService: weatherService)
        container.appDependencies.logger.debug("WeatherVM Initiated")
        return vm
    }
    
    func makeForecastViewModel(geoResponse: GeoResponse) -> ForecastViewModel {
        let forecastService = ForecastService(container: container)
        let vm = ForecastViewModel(service: forecastService, geo: geoResponse)
        container.appDependencies.logger.debug("ForecastVM Initiated")
        return vm
    }
}
