//
//  PlayerCRUDViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation
class PlayerCRUDViewModel {

   
    let positions = ["Forward", "Stopper", "Goalkeeper"]
    let countries = ["Turkey", "USA", "Germany","United States","Canada","Brazil"]
    
    let ages = Array(18...40)
    let heights = Array(150...210)
    let weights = Array(50...120)
    
    var selectedAge: Int?
    var selectedHeight: Int?
    var selectedWeight: Int?
    var selectedPosition: String?
    var selectedCountry: String?
    

    func getPositions() -> [String] {
        return positions
    }
    
    func getCountries() -> [String] {
        return countries
    }
    func getAges() -> [Int] {
        return ages
    }
    
    func getHeights() -> [Int] {
        return heights
    }
    
    func getWeights() -> [Int] {
        return weights
    }
    
    func setSelectedPosition(_ position: String) {
        selectedPosition = position
    }

    func setSelectedCountry(_ country: String) {
        selectedCountry = country
    }
    
    func setSelectedAge(_ age: Int) {
        selectedAge = age
    }
    
    func setSelectedHeight(_ height: Int) {
        selectedHeight = height
    }

    func setSelectedWeight(_ weight: Int) {
        selectedWeight = weight
    }
    
    func getSelectedPosition() -> String { return selectedPosition ?? "" }
    func getSelectedCountry() -> String { return selectedCountry ?? "" }
    func getSelectedAge() -> Int { return selectedAge ?? 0 }
    func getSelectedHeight() -> Int { return selectedHeight ?? 0 }
    func getSelectedWeight() -> Int { return selectedWeight ?? 0 }
}
