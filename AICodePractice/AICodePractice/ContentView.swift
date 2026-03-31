//
//  ContentView.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/21/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authController = AuthController()
    
    var body: some View {
        if authController.isUserLoggedIn {
            PersonList()
        } else {
            AuthView(authController: authController)
        }
    }
}

#Preview {
    ContentView()
}
