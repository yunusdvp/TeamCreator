//
//  PlayerListTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit
import Kingfisher


class PlayerListTableViewCell: UITableViewCell {
        
    @IBOutlet private weak var sportTypeIcon: UIImageView!
    @IBOutlet private weak var playerImage: UIImageView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var positionNameLabel: UILabel!
    @IBOutlet private weak var skillPointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with player: Player) {
        playerNameLabel.text = player.name
        positionNameLabel.text = player.position
        skillPointLabel.text = "\(player.skillRating ?? 0)"
        
        switch player.sporType {
        case "football":
            sportTypeIcon.image = UIImage(named: "footballIcon")
        case "volleyball":
            sportTypeIcon.image = UIImage(named: "voleyballIcon")
        case "basketball":
            sportTypeIcon.image = UIImage(named: "basketballIcon")
        default:
            sportTypeIcon.image = UIImage(named: "defaultIcon")
        }
        
        if let profilePhotoURL = player.profilePhotoURL, let url = URL(string: profilePhotoURL) {
            playerImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
        }
    }

}
