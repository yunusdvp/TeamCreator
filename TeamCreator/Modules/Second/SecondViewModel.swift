//
//  SecondViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import Foundation

protocol SecondViewModelProtocol: AnyObject {
    var delegate: SecondViewModelDelegate? { get set }
    
    func fetchMatches()
    func getMatchesCount() -> Int
    func getMatch(at index: Int) -> Matches
    func selectMatch(at index: Int)
}

protocol SecondViewModelDelegate: AnyObject {
    func reloadCollectionView()
    func navigateToMatchCreate()
    func navigateToPlayerList()
}

final class SecondViewModel: SecondViewModelProtocol {
    
    weak var delegate: SecondViewModelDelegate?
    private var matches: [Matches] = []
    
    init(delegate: SecondViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchMatches() {
        let players = Matches(category: "Players", backgroundImage: "players")
        let create = Matches(category: "Create Match", backgroundImage: "createMatch")
        let myMatches = Matches(category: "My Matches", backgroundImage: "myMatches")
        matches.append(contentsOf: [players, create, myMatches])
        delegate?.reloadCollectionView()
    }
    
    func getMatchesCount() -> Int {
        return matches.count
    }
    
    func getMatch(at index: Int) -> Matches {
        return matches[index]
    }
    func selectMatch(at index: Int) {
        switch index{
            case 0:
                delegate?.navigateToPlayerList()
            case 1:
                delegate?.navigateToMatchCreate()
            default:
                break
        }
    
    }
    
}
