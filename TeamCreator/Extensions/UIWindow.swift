//
//  UIWindow.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 8.08.2024.
//

import UIKit

extension UIWindow {
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        let transition: CATransition = {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            return transition
        }()

        self.layer.add(transition, forKey: kCATransition)
        self.rootViewController = viewController
        makeKeyAndVisible()
        
        if animated {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: { _ in
                completion?()
            })
        } else {
            completion?()
        }
    }
}
