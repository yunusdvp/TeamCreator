//
//  OnboardModule.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import Foundation

import UIKit

final class OnboardModule {
    
    static func createModule() -> OnboardViewController {
        let view = OnboardViewController()
        let coordinator = OnboardCoordinator(viewController: view)
        let viewModel = OnboardViewModel(view: view, coordinator: coordinator)
        view.viewModel = viewModel
        return view
    }
}
