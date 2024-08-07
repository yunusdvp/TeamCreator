//
//  GenderTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit
protocol GenderTableViewCellDelegate: AnyObject {
    func didChangeGender(to gender: String)
}

class GenderTableViewCell: UITableViewCell {
    var onGenderSelected: ((String) -> Void)?
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genderSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged() {
        let selectedGender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) ?? ""
        onGenderSelected?(selectedGender)
    }
}
