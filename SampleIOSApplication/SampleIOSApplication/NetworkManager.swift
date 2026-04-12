//
//  NetworkManager.swift
//  SampleIOSApplication
//
//  Created by Prasad Kukkala on 4/7/26.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case badResponse
    case invalidResponse
    case decodeError
}

protocol BackendProtocol {
    func fetchProducts(urlString: String) async throws -> Result<Products, NetworkError>
}

class NetworkManager: BackendProtocol {
    var urlSession: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        return URLSession(configuration: config)
    }
    
    func fetchProducts(urlString: String) async throws -> Result<Products, NetworkError> {
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidUrl)
        }
        
        let (data, response) = try await urlSession.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode),
              !data.isEmpty else {
            return .failure(.badResponse)
        }
        
        do{
            let decoded = try JSONDecoder().decode(Products.self, from: data)
            return .success(decoded)
        }
    }
}
