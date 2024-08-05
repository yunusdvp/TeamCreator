//
//  OnboardingViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 29.07.2024.
//

import UIKit

class OnboardingViewCell: UICollectionViewCell {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func setupCell(_ slide: OnboardingSlide) {
        imageview.image = slide.image
        mainTitleLabel.text = slide.title
        subjectLabel.text = slide.description
      
    }
}
