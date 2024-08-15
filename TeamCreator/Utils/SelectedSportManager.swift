//
//  SelectedSportManager.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 6.08.2024.
//

import Foundation

class SelectedSportManager {
    static let shared = SelectedSportManager()
    
    private init() {}
    
    var selectedSport: SelectedSport?
}
