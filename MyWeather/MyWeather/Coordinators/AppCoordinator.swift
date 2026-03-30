//
//  AppCoordinator.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/14/26.
//

import Foundation
import SwiftUI
import UIKit

enum ApplicationState {
    case loggingIn
    case authenticated
    case loggedOut
}

protocol AppCoordinatorProtocol {
    func start() -> UIViewController
}

final class AppCoordinator: AppCoordinatorProtocol {
    let container: DependencyContainer
    private var appState: ApplicationState = .loggingIn
    var window: UIWindow
    
    init(container: DependencyContainer, window: UIWindow) {
        self.container = container
        self.window = window
    }
    
    func start() -> UIViewController {
       
       switch appState {
       case .loggingIn:
           container.appDependencies.analytics.track(.screenView(name: "Showing Login View.."))
           return showLoginFlow()
       case .authenticated:
           container.appDependencies.analytics.track(.screenView(name: "Showing Main flow View.."))
           showMainFlow()
       case .loggedOut:
           container.appDependencies.analytics.track(.error(code: 25, message: "Logged out"))
           EmptyView()
        }
        return UIViewController()
    }
    
    func showLoginFlow() -> UIViewController {
        // Show login screen
        let loginFlow = LoginView()
        loginFlow.loginVM.isAuthenticated = {
            //Show Navigation flow
            Task { @MainActor [weak self] in
                guard let self else { return }
                appState = .authenticated
                container.appDependencies.logger.info("User Authenticated")
                _ = self.start()
            }
        }
        let loginVC = UIHostingController(rootView: loginFlow)
        container.appDependencies.logger.info("Login Flow Initiated")
        return loginVC
    }
    
    func showMainFlow() {
        let weatherFlow = WeatherFlowCoordinator(container: container)
        window.rootViewController = nil
        window.rootViewController = weatherFlow.start()
    }
}
