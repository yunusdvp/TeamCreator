//
//  SplashViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

protocol SplashViewModelProtocol: AnyObject {
    var delegate: SplashViewControllerProtocol? { get set }
    
    func viewDidLoad()
}

enum SplashViewState {
    case showOnboarding
    case noInternetConnection
}

final class SplashViewModel: SplashViewModelProtocol {
    
    weak var delegate: SplashViewControllerProtocol?
    
    init() {}
    
    func viewDidLoad() {
        checkInternetConnection()
    }
    
    private func checkInternetConnection() {
        let internetStatus = API.shared.isConnectoInternet()
        if internetStatus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.delegate?.updateUI(for: .showOnboarding)
            }
        } else {
            delegate?.updateUI(for: .noInternetConnection)
        }
    }
}
