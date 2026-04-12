//
//  SampleIOSApplicationApp.swift
//  SampleIOSApplication
//
//  Created by Prasad Kukkala on 4/7/26.
//

import SwiftUI

@main
struct SampleIOSApplicationApp: App {
    var body: some Scene {
        WindowGroup {
            let vm = ViewModel(networkManager: NetworkManager())
            ProductView(viewModel: vm)
        }
    }
}
