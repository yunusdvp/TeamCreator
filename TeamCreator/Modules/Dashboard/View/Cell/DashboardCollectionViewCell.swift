//
//  SecondCollectionViewCell.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!

    static let identifier = "SecondCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    private func setupView() {
        backgroundImageView.layer.cornerRadius = 7.6
        backgroundImageView.clipsToBounds = true
        layer.cornerRadius = 10

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }

    func configure(with item: DashboardItem) {
        if let category = item.category {
            categoryLabel.text = category
        }
        if let image = item.backgroundImage {
            backgroundImageView.image = UIImage(named: image)

        }
    }
}
