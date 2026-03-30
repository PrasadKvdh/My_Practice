//
//  LoginView.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import SwiftUI

struct LoginView: View {
    @State var loginVM: LoginVM = .init()
    @State var email: String = "testUser@gmail.com"
    @State var password: String = ""
    
    var body: some View {
        VStack {
            showLoginView()
        }
    }
    
    @ViewBuilder
    func showLoginView() -> some View {
        switch loginVM.state {
        case .login:
            loginDefaultView
            loginButton
        case .loginInProgress:
            ProgressView()
        case .deviceNotSupported, .loginFailed:
            loginDefaultView
            manualLoginView
        case .loginSuccess:
            //Show App homeView
            EmptyView()
        }
    }
    
    @ViewBuilder
    var loginDefaultView: some View {
         VStack {
             Text("Login Screen")
                 .font(.largeTitle)
                 .padding()
             
             Text("Authentication is required to access App")
                 .font(.subheadline)
                 .padding()
        }
    }
    
    @ViewBuilder
    var loginButton: some View {
        Button("Login") {
            switch loginVM.state {
            case .login:
                loginVM.deviceAuthentication()
            case .deviceNotSupported:
                loginVM.manualAuthentication(email: email, password: password)
            default:
                print("Unsupported case for Login state at button action \(loginVM.state)")
            }
        }
        .frame(width: 100, height: 30)
        .font(.title)
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    @ViewBuilder
    var manualLoginView: some View {
        TextField("Email", text: $email)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        
        SecureField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        
        if loginVM.state == .loginFailed {
            Text("Please enter correct password and try again...")
                .font(.subheadline)
                .foregroundColor(.red)
                .foregroundStyle(.brown)
                .multilineTextAlignment(.center)
                .padding()
        }
        
        loginButton
    }
}
