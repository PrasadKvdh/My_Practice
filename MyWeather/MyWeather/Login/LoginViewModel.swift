//
//  LoginViewModel.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import Foundation
import LocalAuthentication
import Observation

enum LoginState {
    case login
    case loginInProgress
    case deviceNotSupported
    case loginSuccess
    case loginFailed
}

@Observable
class LoginVM {
    var state: LoginState = .login
    var laContext = LAContext()
    var isAuthenticated: (() -> Void)?
    
    func deviceAuthentication() {
        state = .loginInProgress
        let reason = "Authentication is required to access Weather App"
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, authenticationError in
                guard let self else { return }
                if success {
                    //Login Success - Allow user to ente into App
                    state = .loginSuccess
                    isAuthenticated?()
                } else {
                    //Error need to show manual authentication screen
                    state = .deviceNotSupported
                }
            }
        }
    }
    
    //This to
    func manualAuthentication(email: String, password: String) {
        state = .loginInProgress
        if email == "testUser@gmail.com" && password == "1234" {
            //Login Success - Allow user to ente into App
            state = .loginSuccess
            isAuthenticated?()
        } else {
            //Error need to show same manual authentication screen
            state = .loginFailed
        }
    }
}
