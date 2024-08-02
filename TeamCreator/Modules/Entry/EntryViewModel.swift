//
//  EntryViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

protocol EntryViewModelProtocol: AnyObject {
    var sports: [Sport] { get }
    
    func fetchSports()
}


class EntryViewModel: EntryViewModelProtocol {
    
    weak var view: EntryViewControllerProtocol?
    var coordinator: EntryCoordinatorProtocol?
    var sports: [Sport] = []
    
    init(view: EntryViewControllerProtocol) {
        self.view = view
    }
    init(view: EntryViewControllerProtocol, coordinator: EntryCoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func fetchSports() {
        let sports1 = Sport(name: "Football", backgroundImage: "football5")
        let sports2 = Sport(name: "Volleyball", backgroundImage: "volleyball")
        let sports3 = Sport(name: "Basketball", backgroundImage: "basketball")
        sports.append(contentsOf: [sports1, sports2, sports3])
        view?.reloadCollectionView()
    }
}
