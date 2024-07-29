//
//  SplashModule.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import UIKit

final class SplashModule {
    
    static func createModule() -> SplashViewController {
        let view = SplashViewController()
        let coordinator = SplashCoordinator(viewController: view)
        let viewModel = SplashViewModel(view: view, coordinator: coordinator)
        view.viewModel = viewModel
        return view
    }
}
