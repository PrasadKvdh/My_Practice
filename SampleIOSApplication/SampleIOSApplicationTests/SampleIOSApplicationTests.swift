//
//  SampleIOSApplicationTests.swift
//  SampleIOSApplicationTests
//
//  Created by Prasad Kukkala on 4/7/26.
//

import Foundation
import Testing
@testable import SampleIOSApplication

@Suite("SampleIOSApplication end-to-end and unit tests")
struct SampleIOSApplicationTests {

    // MARK: - Model decoding test with sample JSON
    @MainActor
    @Test("Decode products payload")
    func decodeProductsSample() throws {
        // Example payload adapted from https://dummyjson.com/products
        let json = """
        {"products":[{"id":1,"title":"Test Item","description":"Desc","price":10,"discountPercentage":0.0,"rating":4.5,"stock":5,"brand":"Brand","category":"cat","thumbnail":"https://example.com/thumb.jpg","images":["https://example.com/img1.jpg"]}],"total":1,"skip":0,"limit":30}
        """.data(using: .utf8)!

        // Replace ProductList with your concrete decodable type if different
        let decoded = try JSONDecoder().decode(Products.self, from: json)
        #expect(decoded.products.count == 1)
        let first = try #require(decoded.products.first)
        #expect(first.id == 1)
        #expect(first.title == "Test Item")
    }

    // MARK: - Network integration test (hit live endpoint)
    @MainActor
    @Test("Fetch products from live endpoint", .timeLimit(.minutes(1)))
    func fetchProductsLive() async throws {
        let manager = NetworkManager()
        let result = try await manager.fetchProducts(urlString: "https://dummyjson.com/products")
        switch result {
        case .success(let list):
            #expect(!list.products.isEmpty)
        case .failure(let error):
            Issue.record("Network request failed: \(error)")
            #expect(Bool(false), "Expected success fetching products")
        }
    }

    // MARK: - ViewModel integration test
    //@MainActor
    @Test("ViewModel integrates with NetworkManager")
    func viewModelLoadsProducts() async throws {
        let vm = await ViewModel(networkManager: NetworkManager())
        let result = try await vm.networkManager.fetchProducts(urlString: "https://dummyjson.com/products")
        switch result {
        case .success(let list):
            let isEmpty = await list.products.isEmpty
            #expect(!isEmpty)
        case .failure(let error):
            Issue.record("ViewModel/network error: \(error)")
            #expect(Bool(false), "Expected success from ViewModel fetch")
        }
    }
}
