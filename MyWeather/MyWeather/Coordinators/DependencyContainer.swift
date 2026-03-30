//
//  DependencyContainer.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/14/26.
//

import Foundation

struct AppDependencies {
    let logger: LoggingManager
    let analytics: AnalyticsManager
    let network: NetworkManager
}

final class DependencyContainer {
    let appDependencies: AppDependencies
    
    init() {
        let logger = LoggingManager()
        self.appDependencies = AppDependencies(logger: logger,
                                               analytics: AnalyticsManager.shared,
                                               network: NetworkManager(logger: logger))
    }
}
