//
//  SplashViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

protocol SplashViewModelProtocol: AnyObject {
    var onInternetStatusChecked: (() -> Void)? { get set }
    var onNoInternet: (() -> Void)? { get set }
    func checkInternetConnection()
}

final class SplashViewModel: SplashViewModelProtocol {
    
    weak var view: SplashViewControllerProtocol?
    var coordinator: SplashCoordinatorProtocol?
    
    var onInternetStatusChecked: (() -> Void)?
    var onNoInternet: (() -> Void)?
    
    init(view: SplashViewControllerProtocol, coordinator: SplashCoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
        
    }
    
    func checkInternetConnection() {
        let internetStatus = API.shared.isConnectoInternet()
        if internetStatus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.onInternetStatusChecked?()
                print("internet bağlantısı mevcut")
            }
        } else {
            onNoInternet?()
        }
    }
}
