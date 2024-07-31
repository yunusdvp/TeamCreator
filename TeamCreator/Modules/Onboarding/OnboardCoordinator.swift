//
//  OnboardCoordinator.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import Foundation
import UIKit

protocol OnboardCoordinatorProtocol: AnyObject {
    func navigateToEntry()
}

final class OnboardCoordinator: OnboardCoordinatorProtocol {
    
    weak var viewController: OnboardViewController?
    
    init(viewController: OnboardViewController) {
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
