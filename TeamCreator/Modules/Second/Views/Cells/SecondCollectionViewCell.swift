//
//  SecondCollectionViewCell.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let identifier = "SecondCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        //addBlurEffect()
        addGradientLayer()
        
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
    
    func configure(with matches: Matches) {
        if let category = matches.category {
            categoryLabel.text = category
        }
        if let image = matches.backgroundImage {
            backgroundImageView.image = UIImage(named: image)
            
        }
        
        
    }
    private func addBlurEffect() {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backgroundImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundImageView.addSubview(blurEffectView)
        }
    private func addGradientLayer() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = backgroundImageView.bounds
            gradientLayer.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Başlangıç noktası (üst orta)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            backgroundImageView.layer.addSublayer(gradientLayer)
        }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            // Gradyan katmanının boyutunu hücre boyutuna göre ayarlama
            if let gradientLayer = backgroundImageView.layer.sublayers?.first as? CAGradientLayer {
                gradientLayer.frame = backgroundImageView.bounds
            }
        }
    

}
