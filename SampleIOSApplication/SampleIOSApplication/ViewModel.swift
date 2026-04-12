//
//  ViewModel.swift
//  SampleIOSApplication
//
//  Created by Prasad Kukkala on 4/7/26.
//

import Foundation
import Combine


enum ViewState {
    case idle
    case loading
    case loaded(DisplayModel)
    case error(String)
}

protocol productsViewProtocol {
    func getProductList()
}

class ViewModel: ObservableObject, productsViewProtocol {
    @Published var viewState: ViewState = .idle
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getProductList() {
        viewState = .loading
        Task {
            do {
                let urlString = "https://dummyjson.com/products"
                let response = try await networkManager.fetchProducts(urlString: urlString)
                
                switch response {
                case .success(let products):
                    let list = DisplayModel(allProducts: products.products)
                    viewState = .loaded(list)
                case .failure(let error):
                    viewState = .error(error.localizedDescription)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
