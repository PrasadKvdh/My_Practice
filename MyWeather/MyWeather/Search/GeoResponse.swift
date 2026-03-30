//
//  Geo.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import Foundation

struct GeoResponse: Decodable, Hashable, Equatable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon, country, state
    }
}
