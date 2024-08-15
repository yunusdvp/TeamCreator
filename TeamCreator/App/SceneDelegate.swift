//
//  SceneDelegate.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 26.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
 
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           guard let windowScene = (scene as? UIWindowScene) else { return }
           let window = UIWindow(windowScene: windowScene)
           

           let storyboard = UIStoryboard(name: "SplashViewController", bundle: nil)
           guard let playerListViewController = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController else {
               return
           }

           window.rootViewController = playerListViewController
           window.makeKeyAndVisible()
           self.window = window
       }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

