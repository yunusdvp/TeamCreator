//
//  SecondViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import Foundation

protocol SecondViewModelInterface: AnyObject {
    var matches: [Matches] { get }
    func fetchMatches()
}

protocol SecondViewInterface: AnyObject {
    func reloadCollectionView()
}

class SecondViewModel: SecondViewModelInterface {
    
    weak var view: SecondViewInterface?
    var matches: [Matches] = []
    
    init(view: SecondViewInterface) {
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
