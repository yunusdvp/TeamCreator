//
//  SecondViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import Foundation

protocol SecondViewModelProtocol: AnyObject {
    var matches: [Matches] { get }
    func fetchMatches()
}


class SecondViewModel: SecondViewModelProtocol {
    
    weak var view: SecondViewControllerProtocol?
    var coordinator: SecondCoordinatorProtocol?
    var matches: [Matches] = []
    
    init(view: SecondViewControllerProtocol,coordinator: SecondCoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
        
    }
    init(view: SecondViewControllerProtocol) {
        self.view = view
    }
    
    func fetchMatches() {
        let players = Matches(category: "Players", backgroundImage: "players")
        let create = Matches(category: "Create Match", backgroundImage: "createMatch")
        let myMatches = Matches(category: "My Matches", backgroundImage: "myMatches")
        matches.append(contentsOf: [players, create, myMatches])
        view?.reloadCollectionView()
        
    }
}
