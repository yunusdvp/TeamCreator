//
//  MyMatchesViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 13.08.2024.
//

import Foundation

protocol MyMatchesViewModelDelegate: AnyObject {
    func didUpdateMatches()
    func didFailWithError(_ error: Error)
}

class MyMatchesViewModel {
    
    weak var delegate: MyMatchesViewModelDelegate?
    private let repository: MatchRepositoryProtocol
    private var matches: [Match] = []
    
    init(repository: MatchRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchMatches(for sport: String) {
        repository.fetchMatches(sport: sport) { [weak self] result in
            switch result {
            case .success(let matches):
                self?.matches = matches
                self?.delegate?.didUpdateMatches()
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    func removeMatch(_ match: Match) {
        guard let matchId = match.id else {
            return
        }
        
        repository.removeMatch(matchId: matchId) { [weak self] result in
            switch result {
            case .success:
                if let index = self?.matches.firstIndex(where: { $0.id == matchId }) {
                    self?.matches.remove(at: index)
                    self?.delegate?.didUpdateMatches()
                }
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    func numberOfRows() -> Int {
        return matches.count
    }
    
    func match(at index: Int) -> Match {
        return matches[index]
    }
}


