//
//  BaseViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import UIKit

class BaseViewController: UIViewController, LoadingShowable {

    private var backTargetViewController: (UIViewController, ((UIViewController) -> Void))?

    //MARK: -Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: -Alert Handling
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

    //MARK: - Navigation

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
    func navigateToViewController<T: UIViewController>(
            storyboardName: String,
            viewControllerIdentifier: String,
            configure: (T) -> Void,
            backTo viewControllerWithConfiguration: ((UIViewController) -> Void)? = nil
        ) {
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

            if let backConfiguration = viewControllerWithConfiguration {
                backTargetViewController = (viewController, backConfiguration)
            }
        }


    // MARK: - Keyboard Handling

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            adjustForKeyboard(height: keyboardHeight)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustForKeyboard(height: 0)
    }

    private func adjustForKeyboard(height: CGFloat) {
        DispatchQueue.main.async {
            if let scrollView = self.findScrollView(in: self.view) {
                UIView.animate(withDuration: 0.3) {
                    scrollView.contentInset.bottom = height
                    scrollView.scrollIndicatorInsets.bottom = height
                }
            }
        }
    }
    // MARK: - Utility Methods
    private func findScrollView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for subview in view.subviews {
            if let scrollView = findScrollView(in: subview) {
                return scrollView
            }
        }
        return nil
    }
}
