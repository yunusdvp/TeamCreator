//
//  PlayerNameTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

class PlayerNameTableViewCell: UITableViewCell {
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerNameLabel: UILabel!
    
    var onNameChange: ((String) -> Void)?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            playerNameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        }
        
        @objc private func nameChanged() {
            onNameChange?(playerNameTextField.text ?? "")
        }

}
