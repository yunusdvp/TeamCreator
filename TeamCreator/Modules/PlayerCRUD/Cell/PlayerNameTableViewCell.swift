//
//  PlayerNameTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

class PlayerNameTableViewCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var onNameChange: ((String) -> Void)?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            playerNameTextField.delegate = self
            playerNameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        }
        
        @objc private func nameChanged() {
            onNameChange?(playerNameTextField.text ?? "")
        }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return true
        }

}
