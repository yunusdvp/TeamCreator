//
//  PlayerOtherPropertyTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit
protocol PlayerOtherPropertyTableViewCellDelegate: AnyObject {
    
    func didChangeSkillPoint(_ skillPoint: Int)
    func ageTextFieldDidChange()
}
class PlayerOtherPropertyTableViewCell: UITableViewCell {
    weak var delegate: PlayerOtherPropertyTableViewCellDelegate?
    var viewModel: PlayerCRUDViewModelProtocol?
    @IBOutlet weak var skillPointTextLabel: UITextField!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var skillPointLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        skillPointTextLabel.keyboardType = .numberPad
        ageTextField.keyboardType = .numberPad
        
        ageTextField.delegate = self
        skillPointTextLabel.delegate = self
        skillPointTextLabel.addTarget(self, action: #selector(skillPointTextFieldDidChange), for: .editingChanged)
        ageTextField.delegate = self
        ageTextField.addTarget(self, action: #selector(ageTextFieldDidChange), for: .editingChanged)
    }
    
    
    
    
    
}

extension PlayerOtherPropertyTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc private func skillPointTextFieldDidChange() {
        if let skillPointText = skillPointTextLabel.text, let skillPoint = Int(skillPointText) {
            viewModel?.updateSkillPoint(skillPoint)
        }
    }
    @objc private func ageTextFieldDidChange() {
        if let ageText = ageTextField.text, let age = Int(ageText) {
            viewModel?.updatePlayerAge(age)
        }
    }
}
