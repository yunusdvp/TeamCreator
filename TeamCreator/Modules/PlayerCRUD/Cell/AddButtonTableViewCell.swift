//
//  AddButtonTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

class AddButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerAddButton: UIButton!
    var onAddButtonTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func playerAddButtonClicked(_ sender: UIButton) {
        if let viewController = self.findViewController() as? PlayerCRUDViewController {
            if !viewController.validateForm() {
                let alert = UIAlertController(title: "Eksik Alan", message: "Lütfen tüm alanları doldurduğunuzdan emin olun.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                return
            }
        }
        onAddButtonTapped?()
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
