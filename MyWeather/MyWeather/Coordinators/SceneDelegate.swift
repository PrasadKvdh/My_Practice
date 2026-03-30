//
//  SceneDelegate.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/13/26.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator?
    private var containter: DependencyContainer?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let container = DependencyContainer()
        let coordinator = AppCoordinator(container: container, window: window)
        self.coordinator = coordinator
        self.containter = container
        
        window.rootViewController = coordinator.start()
        self.window = window
        window.makeKeyAndVisible()
    }
}


    
