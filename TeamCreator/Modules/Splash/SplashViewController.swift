//
//  SplashViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func updateUI(for state: SplashViewState)
}

final class SplashViewController: BaseViewController {
    
    var viewModel: SplashViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SplashViewModel()
        viewModel.viewDidLoad()
    }
}

extension SplashViewController: SplashViewControllerProtocol {
    func updateUI(for state: SplashViewState) {
        switch state {
        case .showOnboarding:
            navigateToOnboard()
        case .noInternetConnection:
            showAlert("Error", "No Internet connection, please check your connection")
        }
    }
    
    private func navigateToOnboard() {
        guard let window = view.window else { return }
        let storyboard = UIStoryboard(name: "OnboardViewController", bundle: nil)
        guard let onboardVC = storyboard.instantiateViewController(withIdentifier: "OnboardViewController") as? OnboardViewController else {
            return
        }
        
        let onboardViewModel = OnboardViewModel()
        onboardVC.viewModel = onboardViewModel
        
        window.rootViewController = onboardVC
        window.makeKeyAndVisible()
    }
}
