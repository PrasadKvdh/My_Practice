//
//  ProductView.swift
//  SampleIOSApplication
//
//  Created by Prasad Kukkala on 4/7/26.
//

import SwiftUI

struct ProductView: View {
    @ObservedObject var viewModel: ViewModel
    @State var isInspectorShown = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        LoadContent
            .onAppear {
                viewModel.getProductList()
            }
            .inspector(isPresented: $isInspectorShown) {
                Text("Shown Inspector")
            }
    }
    
    @ViewBuilder
    var LoadContent: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .loaded(let displayModel):
            //Show List View
            showProdutsList(model: displayModel)
        case .error(let errorString):
            Text(errorString)
                .foregroundStyle(.red)
                .padding()
        default:
            Text("Unsupported Option")
        }
    }
        
    @ViewBuilder
    func showProdutsList(model: DisplayModel) -> some View {
        VStack {
            List(model.allProducts) { product in
                //Show Product Card
                showProductCard(item: product)
            }
        }
    }
    
    @ViewBuilder
    func showProductCard(item: Product) -> some View {
        VStack {
            Text(item.title)
                .font(.headline)
                .padding()
            
            Text(item.description)
                .font(.subheadline)
                .padding()
        }
    }
}
