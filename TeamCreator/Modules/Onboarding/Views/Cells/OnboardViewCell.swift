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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ slide: OnboardSlide) {
        subjectLabel.text = slide.title
        titleLabel.text = slide.description
        imageView.image = slide.image
        
    }
    
}
