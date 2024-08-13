//
//  AddButtonTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit
protocol AddButtonTableViewCellDelegate: AnyObject {
    func didTapAddButton(success: Bool)
}
class AddButtonTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet private weak var playerAddButton: UIButton!

    weak var delegate: AddButtonTableViewCellDelegate?
    
    var viewModel: PlayerCRUDViewModelProtocol? {
            didSet {
                updateButtonTitle()
            }
        }
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonTitle()

    }
    func updateButtonTitle() {
            if viewModel?.player != nil {
                playerAddButton.setTitle("Update", for: .normal)
            } else {
                playerAddButton.setTitle("Add", for: .normal)
            }
        }
    @IBAction func playerAddButtonClicked(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
                if !viewModel.isFormValid() {
                    showValidationAlert()
                    return
                }
                viewModel.addOrUpdatePlayer()
                
                delegate?.didTapAddButton(success: true)
    }
    private func showValidationAlert() {
            let alert = UIAlertController(title: "Missing Field", message: "Please make sure you have filled in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            findViewController()?.present(alert, animated: true, completion: nil)
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

