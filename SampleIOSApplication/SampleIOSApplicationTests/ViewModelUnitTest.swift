//
//  ViewModelUnitTest.swift
//  SampleIOSApplication
//
//  Created by Prasad Kukkala on 4/8/26.
//

import XCTest
import Combine
@testable import SampleIOSApplication

class MockNetworkManager: NetworkManager {
    var stubbedResult: Result<Products, NetworkError>?
    var isFetchProductsCalled = false
    var fetchProductsCalledWithUrl: String?
    
    override func fetchProducts(urlString: String) async throws -> Result<Products, NetworkError> {
        isFetchProductsCalled = true
        fetchProductsCalledWithUrl = urlString
        //stubbedResult = .failure(NetworkError.badResponse)
        guard let result = stubbedResult else {
            throw URLError(.unknown)
        }
        return result
    }
}

extension Product {
    static func make(
        id: Int = 1,
        title: String = "Test Product",
        desctription: String = "A Test Product") -> Product {
            Product(id: id, title: title, description: desctription)
        }
}

final class ViewModelUnitTest: XCTestCase {
    var sut: ViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = ViewModel(networkManager: mockNetworkManager)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func test_initialState_isIdle() {
        if case .idle = sut.viewState {
            //Pass Testcase
        } else {
            XCTFail("Expected Initial state to be .idle, got \(sut.viewState)")
        }
    }
    
    func test_getProducts_SetsLoadingState() {
        let expectation = XCTestExpectation(description: "Viewstate transistion to .loading")
        sut.$viewState
            .sink { state in
                if case .loading = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.getProductList()
        wait(for: [expectation], timeout: 1.0)
    }
    
    @MainActor
    func test_getproducts_SetLoadedState() async {
        let products = [Product(id: 1, title: "Test Product 1", description: "First Product"), Product(id: 2, title: "Test Product 2", description: "Second Product")]
        let productResponse = Products(products: products)
        mockNetworkManager.stubbedResult = .success(productResponse)
        
        let expectation = XCTestExpectation(description: "Viewstate transistion to .loaded")
        sut.$viewState
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.getProductList()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        if case .loaded(let model) = sut.viewState {
            XCTAssertEqual(model.allProducts.count, 2)
            XCTAssertEqual(model.allProducts.first?.title, "Test Product 1")
        } else {
            XCTFail("Expected .loaded state, got \(sut.viewState)")
        }
    }
    
    @MainActor
    func test_getproducts_SetLoadedState_WithNoItems() async {
        let productResponse = Products(products: [])
        mockNetworkManager.stubbedResult = .success(productResponse)
        
        let expectation = XCTestExpectation(description: "Viewstate transistion to .loaded")
        sut.$viewState
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.getProductList()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        if case .loaded(let model) = sut.viewState {
            XCTAssertTrue(model.allProducts.isEmpty)
        } else {
            XCTFail("Expected .loaded state, got \(sut.viewState)")
        }
    }
}
