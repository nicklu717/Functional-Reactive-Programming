//
//  SceneDelegate.swift
//  FunctionalReactiveProgramming
//
//  Created by 陸瑋恩 on 2020/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = BasicViewController()
//        window?.rootViewController = ComplexViewController()
        window?.makeKeyAndVisible()
    }
}
