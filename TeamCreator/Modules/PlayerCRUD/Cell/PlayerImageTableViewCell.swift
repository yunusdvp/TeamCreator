//
//  PlayerImageTableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

class PlayerImageTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var profileImageView: UIImageView!
    var onImageTapped: (() -> Void)?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGesture()
    }
    
    // MARK: - Setup Methods
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func imageTapped() {
        onImageTapped?()
    }
}
