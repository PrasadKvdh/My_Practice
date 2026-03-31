//
//  FaceIDIntegration.swift
//  DisplayScreen
//
//  Created by mac_admin on 11/20/25.
//

import SwiftUI
import LocalAuthentication

struct FaceIDAuthenticator {
    private var context = LAContext()
    
    func canAuthenticateWithBiometrics() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access to your data") { success, authenticationError in
            DispatchQueue.main.async {
                completion(success, authenticationError)
            }
        }
    }
}

struct FaceIDView: View {
    let authenticator = FaceIDAuthenticator()
    @State var canShowMainView = false
    
    var body: some View {
        Button("FaceId Login") {
            loginWithFaceID()
       }
        
        showMainView
    }
    
    @ViewBuilder
    private var showMainView: some View {
    // Either case of faceid login success or failure, showing iOS Native transparent swiping view
        if canShowMainView {
            ContentView()
        }
    }
    
    func loginWithFaceID() {
        if authenticator.canAuthenticateWithBiometrics() {
            authenticator.authenticateUser { success, error in
                if success {
                    print("FaceId login success")
                    self.canShowMainView = true
                } else {
                    if let error = error as? LAError {
                        switch error.code {
                        case .userCancel:
                            print("Authentication was cancelled by the user.")
                        case .authenticationFailed:
                            print("The user failed to provide valid credentials.")
                        case .passcodeNotSet:
                            print("A passcode is not set on this device.")
                        case .systemCancel:
                            print("The system canceled authentication.")
                        default:
                            print("Unknown authetication error.")
                        }
                        
                    }
                }
            }
        } else {
            print("Device not supported to use FaceId.")
            //Setting true in failure case to demo IOS native swiping transparent view
            self.canShowMainView = true
        }
    }
}


#Preview {
    FaceIDView()
}
