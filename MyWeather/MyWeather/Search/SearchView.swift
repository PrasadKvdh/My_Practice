//
//  SearchView.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: SearchViewModel
    @State var searchText: String = ""
    @State var viewState: SearchViewState = .idle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            loadContent
            ListContent
            showSearchView
        }
        .padding()
        .navigationTitle("Weather")
    }
    
    @ViewBuilder
    var loadContent: some View {
        switch viewState {
        case .loading:
            ProgressView()
        case .failure(let errorStr):
            showErrorView(str: errorStr)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var ListContent: some View {
            if vm.geoResponses.isEmpty {
                Text("No results yet.")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            } else {
                List(vm.geoResponses) { response in
                    VStack(alignment: .leading, spacing: 4) {
                        Button {
                            vm.navigateToWeatherDetails(selectedGeo: response)
                        } label: {
                            VStack{
                                Text(response.name)
                                    .tag(response.id)
                                    .font(.headline.bold())
                                if !response.state.isEmpty {
                                    Text(response.state)
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                    }
                    .padding(.vertical, 8)
                }
            }
    }
    
    @ViewBuilder
    var showSearchView: some View {
            VStack(spacing: 16) {
                if searchText.isEmpty {
                    showErrorView(str: "Search String is Empty")
                }
                HStack {
                    TextField("Enter City/State Code/Country", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .cornerRadius(10)
                        .border(Color.gray.opacity(0.3), width: 1)
                    Button("Search") {
                        Task {
                            await vm.searchGeo(searchString: searchText)
                        }
                    }
                }
            }
        }
    
    @ViewBuilder
    func showErrorView(str: String) -> some View {
        Text(str)
            .font(.subheadline)
            .foregroundStyle(.red)
    }
}
