//
//  ForescastResponse.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//
import Foundation

struct ForecastResponse: Decodable {
    let list: [DataList]
}

struct DataList: Decodable, Identifiable {
    var id: UUID = UUID()
    let dt: Int
    let main: Main
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather
    }
}

struct clouds: Decodable {
    let all: Int
}

struct wind: Decodable {
    let speed: Double
}
