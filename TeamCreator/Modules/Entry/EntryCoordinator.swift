//
//  EntryCoordinator.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 2.08.2024.
//

import UIKit

protocol EntryCoordinatorProtocol: AnyObject {
    func navigateToSecond()
}

final class EntryCoordinator: EntryCoordinatorProtocol {
    
    weak var viewcontroller: EntryViewController?
    
    init(viewcontroller: EntryViewController) {
        self.viewcontroller = viewcontroller
    }
    
    func navigateToSecond() {
        guard let window = viewcontroller?.view.window else { return }
        let storyboard = UIStoryboard(name: "SecondViewController", bundle: nil)
        
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            return
            
        }
        let secondCoordinator = SecondCoordinator(viewController: secondVC)
        let secondViewModel = SecondViewModel(view: secondVC, coordinator: secondCoordinator)
        secondVC.viewModel = secondViewModel
        
        window.rootViewController = secondVC
        window.makeKeyAndVisible()
        
    }
}

