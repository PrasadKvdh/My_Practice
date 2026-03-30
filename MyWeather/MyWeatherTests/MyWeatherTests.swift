//
//  MyWeatherTests.swift
//  MyWeatherTests
//
//  Created by Prasad Kukkala on 2/13/26.
//

import XCTest
import Testing
@testable import MyWeather

class MockService: SearchGeoServicing {
    func fetchGeoData(searchString: String) async throws -> Result<MyWeather.GeoResponse, MyWeather.NetworkError> {
        try await loadServerData()
    }
    
    func loadServerData() async throws -> Result<MyWeather.GeoResponse, MyWeather.NetworkError> {
        do {
            try await Task.sleep(nanoseconds: 50_000_000)
            return .success(GeoResponse(name: "Test Name", lat: 1313313.2323, lon: 23232323.2323, country: "Test Country", state: "Test State"))
        } catch {
            throw NetworkError.badResponse
        }
    }
}

class myTest: XCTestCase {
    let mockService = MockService()
    
    override func setUp() async throws {
        
    }
    
    override func tearDown() async throws {
        
    }
    
    @MainActor
    func testFetchData() async {
        let expectation = XCTestExpectation(description: "Test Asyn call")

        do {
            let results = try await mockService.fetchGeoData(searchString: "Test URL")
            switch results {
            case .success(let res):
                XCTAssertEqual(res.country, "Test Country")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertTrue(error == .badResponse)
                expectation.fulfill()
            }
        } catch {
            XCTFail("Unexpected throw: \(error)")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testMeasure() {
        let metrics: [XCTMetric] = [XCTMemoryMetric(), XCTCPUMetric()]
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            let expectation = XCTestExpectation(description: "Measure async fetchGeoData")

            // Start measuring just before kicking off the async task
            startMeasuring()

            Task { @MainActor in
                do {
                    _ = try await self.mockService.fetchGeoData(searchString: "Testing Url")
                } catch {
                    // Swallow errors for measurement; the purpose is timing
                }
                // Stop measuring once the async work completes
                self.stopMeasuring()
                expectation.fulfill()
            }

            // Wait synchronously for the async work to complete
            wait(for: [expectation], timeout: 2.0)
        }
    }
}

struct MyWeatherTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
}
