//
//  SplashViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
}

class SplashViewController: BaseViewController {
    
    var viewModel: SplashViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        bindViewModel()
        viewModel.checkInternetConnection()
    }
    
    private func bindViewModel() {
        viewModel.onInternetStatusChecked = { [weak self] in
            self?.navigateToEntry()
        }
        
        viewModel.onNoInternet = { [weak self] in
            self?.noInternetConnection()
        }
    }
    
    func navigateToEntry() {
        (viewModel as? SplashViewModel)?.coordinator?.navigateToEntry()
    }
}

extension SplashViewController: SplashViewControllerProtocol {
    func noInternetConnection() {
        showAlert("Error", "No Internet connection, please check your connection")
    }
}
