//
//  AppleSigIn.swift
//  DisplayScreen
//
//  Created by mac_admin on 11/20/25.
//

import SwiftUI
import AuthenticationServices

struct SignINWithAppleView: View {
    @State private var appleSignInDelegate: ASAuthorizationControllerDelegate?
    
   var body: some View {
        Text("Sign in with Apple")
       
       SignInWithAppleButton(.signIn) { request in
           request.requestedScopes = [.fullName, .email]
       } onCompletion: { result in
           switch result {
               case .success(let authorizationState):
               print("Success \(authorizationState)")
           case .failure(let error):
               print("Failed - \(error.localizedDescription)")
           }
       }
       .frame(width: 300, height: 50)
       .signInWithAppleButtonStyle(.black)
    }
    
    
    init(appleSignInDelegate: ASAuthorizationControllerDelegate? = nil) {
        self.appleSignInDelegate = appleSignInDelegate
    }
}

#Preview {
    SignINWithAppleView()
}
