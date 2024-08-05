//
//  PlayerListTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit

class PlayerListTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var teamIconImage: UIImageView!
    @IBOutlet private weak var playerNoLabel: UILabel!
    @IBOutlet private weak var scoreLAbel: UILabel!
    @IBOutlet private weak var positionNameLabel: UILabel!
    @IBOutlet private weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
