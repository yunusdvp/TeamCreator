//
//  PlayerImageTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit
import Kingfisher

class PlayerImageTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var profileImageView: UIImageView!
    var onImageTapped: (() -> Void)?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGesture()
        makeImageCircular()
    }
    
    // MARK: - Setup Methods
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    private func makeImageCircular() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    @objc private func imageTapped() {
        onImageTapped?()
    }
    
    func configure(with imageUrlString: String?) {
        if let urlString = imageUrlString, let url = URL(string: urlString) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "add"))
        } else {
            profileImageView.image = UIImage(named: "add")
        }
    }
    
    func clearImage() {
        profileImageView.image = UIImage(named: "add")
    }
    
    func updateImage(with image: UIImage) {
        profileImageView.image = image
    }
}
