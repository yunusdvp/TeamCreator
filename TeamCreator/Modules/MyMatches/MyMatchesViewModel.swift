//
//  MyMatchesViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 13.08.2024.
//

import Foundation

class MyMatchesViewModel {
    
    private let repository: MatchRepositoryProtocol
    private var matches: [Match] = []
    
    init(repository: MatchRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchMatches(for sport: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.fetchMatches(sport: sport) { [weak self] result in
            switch result {
            case .success(let matches):
                self?.matches = matches
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteMatch(_ match: Match, completion: @escaping (Bool) -> Void) {
        guard let matchId = match.id else {
            completion(false)
            return
        }
        
        repository.removeMatch(matchId: matchId) { [weak self] result in
            switch result {
            case .success:
                // Firebase'den başarıyla silindiyse, local matches dizisinden de kaldırın
                if let index = self?.matches.firstIndex(where: { $0.id == matchId }) {
                    self?.removeMatch(at: index)
                }
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    func removeMatch(at index: Int) {
        matches.remove(at: index)
    }

    
    func numberOfRows() -> Int {
        return matches.count
    }
    
    func match(at index: Int) -> Match {
        return matches[index]
    }
}


