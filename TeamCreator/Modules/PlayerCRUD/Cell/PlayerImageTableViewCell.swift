//
//  PlayerImageTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

class PlayerImageTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    var onImageTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func imageTapped() {
        onImageTapped?()
    }
}
