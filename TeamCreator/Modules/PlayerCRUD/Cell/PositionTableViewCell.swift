//
//  PozitionTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

// MARK: - PositionTableViewCellDelegate
protocol PositionTableViewCellDelegate: AnyObject {
    func didTapPozitionTextField(cell: PositionTableViewCell)
    func getPositions() -> [String]
    func setSelectedPosition(_ position: String)
}


class PositionTableViewCell: UITableViewCell, UITextFieldDelegate {
    // MARK: - Properties
    @IBOutlet private weak var pozitionLabel: UILabel!
    @IBOutlet private weak var pozitionNameTextField: UITextField!
    
    private var pickerView: UIPickerView!
    private var toolbar: UIToolbar!
    
    weak var delegate: PositionTableViewCellDelegate?
    var viewModel: PlayerCRUDViewModelProtocol?
    
    var onPositionSelected: ((String) -> Void)?
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
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPickerView()
        setupToolbar()
        pozitionNameTextField.inputView = pickerView
        pozitionNameTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - Setup Methods
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

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension PositionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
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
        viewModel?.setSelectedPosition(position)
        onPositionSelected?(position)
    }
}
