//
//  PlayerListTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit
import Kingfisher

/*protocol PlayerListTableViewCellDelegate: AnyObject {
    func didLoadImage(for cell: PlayerListTableViewCell, image: UIImage)
}*/
class PlayerListTableViewCell: UITableViewCell {
    
    //weak var delegate: PlayerListTableViewCellDelegate?
    
    @IBOutlet weak var playerImage: UIImageView!
  
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet private weak var positionNameLabel: UILabel!
 
    @IBOutlet weak var skillPointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with player: Player) {
        playerNameLabel.text = player.name
        positionNameLabel.text = player.position
        skillPointLabel.text = "\(player.skillRating ?? 0)"
        
        if let profilePhotoURL = player.profilePhotoURL, let url = URL(string: profilePhotoURL) {
            playerImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.3))])
        }
        
        
        
    }
    
}
