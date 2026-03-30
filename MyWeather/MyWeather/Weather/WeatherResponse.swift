//
//  WeatherResponse.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import Foundation

struct WeatherResponse: Decodable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let dt: Int
    let timezone: Int
    let name: String
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp,
             tempMin = "temp_min",
             tempMax = "temp_max",
             pressure,
             seaLevel = "sea_level",
             grndLevel = "grnd_level",
             humidity
    }
}
