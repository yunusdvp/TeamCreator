//
//  SplashCoordinator.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import UIKit

protocol SplashCoordinatorProtocol: AnyObject {
    func navigateToOnboard()
}

final class SplashCoordinator: SplashCoordinatorProtocol {
    
    weak var viewController: SplashViewController?
    
    init(viewController: SplashViewController) {
        self.viewController = viewController
    }
    
    func navigateToOnboard() {
        guard let window = viewController?.view.window else { return }
        let storyboard = UIStoryboard(name: "OnboardViewController", bundle: nil) 
        guard let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardViewController") as? OnboardViewController else {
            return
        }
        
        let onboardCoordinator = OnboardCoordinator(viewController: onboardVC)
        let onboardViewModel = OnboardViewModel(view: onboardVC, coordinator: onboardCoordinator)
        onboardVC.viewModel = onboardViewModel
        
        
        window.rootViewController = onboardVC
        window.makeKeyAndVisible()
        
    }
}
