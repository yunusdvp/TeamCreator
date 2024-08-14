//
//  GenderTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

class GenderTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var genderLabel: UILabel!
    
    var onGenderSelected: ((String) -> Void)?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        genderSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged() {
        let selectedGender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) ?? ""
        onGenderSelected?(selectedGender)
    }
}
