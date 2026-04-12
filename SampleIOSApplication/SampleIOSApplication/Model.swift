//
//  Model.swift
//  SampleIOSApplication
//
//  Created by Prasad Kukkala on 4/7/26.
//

import Foundation

struct Product: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct Products: Decodable {
    let products: [Product]
}

struct DisplayModel: Identifiable {
    let id = UUID()
    let allProducts: [Product]
}

