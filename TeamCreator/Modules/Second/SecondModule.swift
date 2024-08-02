//
//  SecondModule.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 2.08.2024.
//

import Foundation

final class SecondModule {
    static func createModule() -> SecondViewController {
        let view = SecondViewController()
        let coordinator = SecondCoordinator(viewController: view)
        let viewmodel = SecondViewModel(view: view, coordinator: coordinator)
        view.viewModel = viewmodel
        return view
    }
}
