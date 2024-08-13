//
//  AddButtonTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit
protocol AddButtonTableViewCellDelegate: AnyObject {
    func didTapButton()
}
class AddButtonTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet private weak var playerAddButton: UIButton!

    var onAddButtonTapped: (() -> Void)?
    weak var delegate: AddButtonTableViewCellDelegate?
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonTitle()

    }
    func updateButtonTitle() {
        if let viewController = self.findViewController() as? PlayerCRUDViewController, viewController.viewModel?.player != nil {
            playerAddButton.setTitle("Update", for: .normal)
        } else {
            playerAddButton.setTitle("Add", for: .normal)
        }
    }
    @IBAction func playerAddButtonClicked(_ sender: UIButton) {
        if let viewController = self.findViewController() as? PlayerCRUDViewController {
            if !viewController.validateForm() {
                let alert = UIAlertController(title: "Missing Field", message: "Please make sure you have filled in all fields.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                return
            }

            onAddButtonTapped?()
            viewController.addPlayer { success in
                if success {
                    viewController.delegate?.didUpdatePlayerList()
                } else {
                }
            }
        }
        delegate?.didTapButton()
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
}
