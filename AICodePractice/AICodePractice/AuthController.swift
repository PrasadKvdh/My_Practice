//
//  AuthController.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/21/25.
//

import LocalAuthentication
import Combine
import SwiftUI

struct AuthView: View {
    @ObservedObject var authController: AuthController
    
    var body: some View {
       VStack {
            Text("App Locked...")
               .font(.largeTitle)
               .padding()
           
            Button("Login") {
                authController.authenticateUser()
            }
            .padding()
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}


class AuthController: ObservableObject {
    
    @Published var isUserLoggedIn = false
    private var context: LAContext = .init()
    
    var isAuthenticated: Result<Bool, Error> {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            return .success(true)
        } else {
            return  .failure(error ?? NSError(domain: "AuthController", code: 0, userInfo: nil))
        }
    }
    
    func authenticateUser() -> Void {
        switch isAuthenticated {
        case .success:
            Task {
                do {
                    try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Login to your account")
                    isUserLoggedIn = true
                    print("Auth Success !!!")
                } catch let error {
                    isUserLoggedIn = false
                    print("AuthController Error: \(error.localizedDescription)")
                }
            }
        case .failure(let error):
            print("AuthController device support Error: \(error.localizedDescription)")
        }
    }
}
