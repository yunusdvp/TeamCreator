//
//  SplashCoordinator.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import UIKit

protocol SplashCoordinatorProtocol: AnyObject {
    func navigateToEntry()
}

final class SplashCoordinator: SplashCoordinatorProtocol {

    weak var viewController: SplashViewController?

    init(viewController: SplashViewController) {
        self.viewController = viewController
    }

    func navigateToEntry() {
        guard let window = viewController?.view.window else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let entryVC = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as? EntryViewController else { return }

        window.rootViewController = entryVC
        window.makeKeyAndVisible()
    }
}
