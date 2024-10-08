//
//  PlayerOtherPropertyTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

// MARK: - PlayerOtherPropertyTableViewCellDelegate
protocol PlayerOtherPropertyTableViewCellDelegate: AnyObject {
    func didChangeSkillPoint(_ skillPoint: Int)
    func ageTextFieldDidChange()
}

class PlayerOtherPropertyTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var skillPointTextLabel: UITextField!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet private weak var skillPointLabel: UILabel!
    
    weak var delegate: PlayerOtherPropertyTableViewCellDelegate?
    var viewModel: PlayerCRUDViewModelProtocol?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        skillPointTextLabel.keyboardType = .numberPad
        ageTextField.keyboardType = .numberPad
        
        ageTextField.delegate = self
        skillPointTextLabel.delegate = self
        skillPointTextLabel.addTarget(self, action: #selector(skillPointTextFieldDidChange), for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(ageTextFieldDidChange), for: .editingChanged)
    }
  
      private func validateSkillPoint(_ skillPoint: Int) -> Bool {
          return skillPoint >= 1 && skillPoint <= 100
      }
    
}

// MARK: - UITextFieldDelegate

extension PlayerOtherPropertyTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        if textField == ageTextField {
            let currentText = (textField.text ?? "") as NSString
            let newText = currentText.replacingCharacters(in: range, with: string)
            return newText.count <= 2
        }
        
        return true
    }
    
    @objc private func skillPointTextFieldDidChange() {
           if let skillPointText = skillPointTextLabel.text, let skillPoint = Int(skillPointText) {
               if validateSkillPoint(skillPoint) {
                   viewModel?.updateSkillPoint(skillPoint)
                   delegate?.didChangeSkillPoint(skillPoint)
               } else {
                   skillPointTextLabel.text = ""
               }
           }
       }

    
    @objc private func ageTextFieldDidChange() {
        if let ageText = ageTextField.text, let age = Int(ageText) {
            viewModel?.updatePlayerAge(age)
            delegate?.ageTextFieldDidChange()
        }
    }
}
