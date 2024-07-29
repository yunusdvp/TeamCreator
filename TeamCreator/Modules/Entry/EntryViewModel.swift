//
//  EntryViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

protocol EntryViewModelInterface: AnyObject {
    var sports: [Sport] { get }
    func fetchSports()
}

protocol EntryViewInterface: AnyObject {
    func reloadCollectionView()
}

class EntryViewModel: EntryViewModelInterface {
    
    weak var view: EntryViewInterface?
    var sports: [Sport] = []
    
    init(view: EntryViewInterface) {
        self.view = view
    }
    
    func fetchSports() {
        let sports1 = Sport(name: "Football", backgroundImage: "football5")
        let sports2 = Sport(name: "Volleyball", backgroundImage: "volleyball")
        let sports3 = Sport(name: "Basketball", backgroundImage: "basketball")
        sports.append(contentsOf: [sports1, sports2, sports3])
        view?.reloadCollectionView()
    }
}
