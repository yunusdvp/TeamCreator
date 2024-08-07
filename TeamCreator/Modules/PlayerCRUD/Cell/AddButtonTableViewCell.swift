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
        onAddButtonTapped?()
    }
    
}
