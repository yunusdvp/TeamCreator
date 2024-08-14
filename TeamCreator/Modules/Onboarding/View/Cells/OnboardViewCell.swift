//
//  OnboardViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import UIKit

class OnboardViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    static let identifier = "OnboardViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(with slide: OnboardSlide) {
        subjectLabel.text = slide.description
        titleLabel.text = slide.title
        imageView.image = UIImage(named: slide.imageName)
    }
    
}
