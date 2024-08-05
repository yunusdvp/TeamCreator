//
//  EntryViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

protocol EntryViewModelProtocol: AnyObject {
    var delegate: EntryViewModelDelegate? { get set }
    
    func fetchSports()
    func getSportsCount() -> Int
    func getSport(at index: Int) -> Sport
    func navigateToSecond()
}

protocol EntryViewModelDelegate: AnyObject {
    func reloadCollectionView()
    func navigateToSecond()
}

final class EntryViewModel: EntryViewModelProtocol {
    
    weak var delegate: EntryViewModelDelegate?
    private var sports: [Sport] = []
    
    init() {
        
    }
    
    func fetchSports() {
        let sports1 = Sport(name: "Football", backgroundImage: "football5")
        let sports2 = Sport(name: "Volleyball", backgroundImage: "volleyball")
        let sports3 = Sport(name: "Basketball", backgroundImage: "basketball")
        sports.append(contentsOf: [sports1, sports2, sports3])
        delegate?.reloadCollectionView()
    }
    
    func getSportsCount() -> Int {
        return sports.count
    }
    
    func getSport(at index: Int) -> Sport {
        return sports[index]
    }
    
    func navigateToSecond() {
        delegate?.navigateToSecond()
    }
}
