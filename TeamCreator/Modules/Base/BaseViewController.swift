//
//  BaseViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import UIKit

class BaseViewController: UIViewController, LoadingShowable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showAlert(_ title: String, _ message: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func navigateToViewController<T: UIViewController>(storyboardName: String, viewControllerIdentifier: String, configure: (T) -> Void) {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T else { return }
            
            configure(viewController)
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                let navigationController = UINavigationController(rootViewController: self)
                view.window?.rootViewController = navigationController
                view.window?.makeKeyAndVisible()
                DispatchQueue.main.async {
                    navigationController.pushViewController(viewController, animated: true)
                }
            }
        }

}
