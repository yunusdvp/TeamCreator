//
//  PlayerListTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit

protocol PlayerListTableViewCellDelegate: AnyObject {
    func didLoadImage(for cell: PlayerListTableViewCell, image: UIImage)
}
class PlayerListTableViewCell: UITableViewCell {

    weak var delegate: PlayerListTableViewCellDelegate?
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet private weak var teamIconImage: UIImageView!
    @IBOutlet private weak var playerNoLabel: UILabel!
    @IBOutlet private weak var scoreLAbel: UILabel!
    @IBOutlet private weak var positionNameLabel: UILabel!
    @IBOutlet private weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with player: Player) {
            playerNoLabel.text = player.name
            positionNameLabel.text = player.position
            scoreLAbel.text = "\(player.skillRating ?? 0)"
            
            if let profilePhotoURL = player.profilePhotoURL {
                loadImage(from: profilePhotoURL)
            }
        }

        private func loadImage(from url: String) {
            NetworkManager.shared.imageStorage.downloadProfileImage(url: url) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.playerImage.image = image
                        self?.delegate?.didLoadImage(for: self!, image: image)
                    }
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }

}
