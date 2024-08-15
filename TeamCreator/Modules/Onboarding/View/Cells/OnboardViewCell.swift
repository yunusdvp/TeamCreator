//
//  OnboardViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import UIKit

class OnboardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
