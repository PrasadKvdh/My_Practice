//
//  AnalyticsManager.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/20/26.
//

import Foundation

enum AnalyticsEvent {
    case screenView(name: String)
    case buttontap(name: String, screen: String)
    case login(method: String)
    case error(code: Int, message: String)
}

protocol AnalyticsProvider {
    func log(_ evnet: AnalyticsEvent)
}

class AnalyticsManager {
    static let shared = AnalyticsManager()
    private var providers: [AnalyticsProvider] = []
    private init() {}
    
    func addProvider(_ provider: AnalyticsProvider) {
        providers.append(provider)
    }
    
    func track(_ event: AnalyticsEvent) {
        providers.forEach { $0.log(event) }
        print("📊 [Analytics] Tracking - \(event)")
    }
}
