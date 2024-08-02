//
//  SecondCoordinator.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 2.08.2024.
//

import Foundation

protocol SecondCoordinatorProtocol: AnyObject {
    
}

final class SecondCoordinator : SecondCoordinatorProtocol {
    weak var viewController: SecondViewController?
    
    init(viewController: SecondViewController) {
        self.viewController = viewController
    }
}
