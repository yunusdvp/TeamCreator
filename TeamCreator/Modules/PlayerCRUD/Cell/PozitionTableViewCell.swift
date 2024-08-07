//
//  PozitionTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit
protocol PozitionTableViewCellDelegate: AnyObject {
    func didTapPozitionTextField(cell: PozitionTableViewCell)
    func getPositions() -> [String]
        func setSelectedPosition(_ position: String)
}
import UIKit

class PozitionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var skillPointLabel: UILabel!
    @IBOutlet private weak var pozitionLabel: UILabel!
    @IBOutlet private weak var pozitionNameTextField: UITextField!
    @IBOutlet private weak var skillPointTextField: UITextField!
    
    private var pickerView: UIPickerView!
    private var toolbar: UIToolbar!
    
    var positions: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    var selectedPosition: String? {
        didSet {
            pozitionNameTextField.text = selectedPosition
        }
    }

    var onPositionSelected: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupPickerView()
        setupToolbar()
        pozitionNameTextField.inputView = pickerView
        pozitionNameTextField.inputAccessoryView = toolbar
    }
    
    private func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setupToolbar() {
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
    }

    @objc private func doneTapped() {
        pozitionNameTextField.resignFirstResponder()
    }
}

extension PozitionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return positions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return positions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let position = positions[row]
        selectedPosition = position
        onPositionSelected?(position)
    }
}
