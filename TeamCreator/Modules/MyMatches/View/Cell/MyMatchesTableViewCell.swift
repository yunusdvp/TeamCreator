//
//  MyMatchesTableViewCell.swift
//  TeamCreator
//
//  Created by Giray Aksu on 13.08.2024.
//

import UIKit

class MyMatchesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var typeImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with match: Match) {
        dateLabel.text = match.dateFormatted
        locationLabel.text = match.location
        hourLabel.text = match.hourFormatted
        typeLabel.text = match.sport
        

        switch SelectedSportManager.shared.selectedSport {
        case .football:
            typeImage.image = UIImage(named: "footballIcon2")
        case .volleyball:
            typeImage.image = UIImage(named: "volleyballIcon")
        case .basketball:
            typeImage.image = UIImage(named: "basketballIcon")
        case .none:
            typeImage.image = nil
        }
    }
}

