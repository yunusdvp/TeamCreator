//
//  AddPlayerButtonTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit

protocol AddPlayerButtonTableViewCellDelegate : AnyObject {
    func didTapButton()
}
class AddPlayerButtonTableViewCell: UITableViewCell {
    
    weak var delegate: (AddPlayerButtonTableViewCellDelegate)?

    @IBOutlet private weak var addPlayerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addPlayerButtonClicked(_ sender: UIButton) {
        delegate?.didTapButton()
    }
    
}

