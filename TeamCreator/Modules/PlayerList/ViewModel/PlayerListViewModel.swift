//
//  PlayerListViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import Foundation
import FirebaseFirestore

enum PlayerListCellType {
    case player
    case addButton
}

protocol PlayerListViewModelProtocol: AnyObject {
    var delegate: PlayerListViewControllerProtocol? { get set }
    
    func fetchPlayers(sporType: String, completion: @escaping (Result<[Player], Error>) -> Void)
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerListCellType
    func getPlayer(at index: Int) -> Player?
    func getPlayerCount() -> Int
    func removePlayer(playerId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func sortPlayersBySkillPoint()
    func toggleSortOrder()
}

final class PlayerListViewModel: PlayerListViewModelProtocol {
    
    weak var delegate: PlayerListViewControllerProtocol?
    
    private var cellTypeList: [PlayerListCellType] = []
    private var players: [Player] = []
    private var isSortedAscending: Bool = true
    
    let playerRepository = NetworkManager.shared.playerRepository
    
    init() {
        self.cellTypeList = [.player, .addButton]
    }
    
    func sortPlayersBySkillPoint() {
        players.sort { (firstPlayer, secondPlayer) -> Bool in
            guard let firstPlayerSkill = firstPlayer.skillRating,
                  let secondPlayerSkill = secondPlayer.skillRating else {
                return false
            }
            return isSortedAscending ? firstPlayerSkill < secondPlayerSkill : firstPlayerSkill > secondPlayerSkill
        }
        delegate?.reloadTableView()
    }
    
    func toggleSortOrder() {
        isSortedAscending.toggle()
        sortPlayersBySkillPoint()
    }
    
    func fetchPlayers(sporType: String, completion: @escaping (Result<[Player], Error>) -> Void) {
        delegate?.showLoading()
        
        let filters: [PlayerFilter] = [.sporType(sporType)]
        playerRepository.fetchPlayers(withFilters: filters) { [weak self] result in
            switch result {
            case .success(let players):
                self?.players = players
                self?.delegate?.reloadTableView()
            case .failure(let error):
                print("Error fetching players: \(error.localizedDescription)")
            }
            self?.delegate?.hideLoading()
            completion(result)
        }
    }
    
    
    func getCellTypeCount() -> Int {
        return cellTypeList.count
    }
    
    func getCellType(at index: Int) -> PlayerListCellType {
        return cellTypeList[index]
    }
    func removePlayer(playerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        playerRepository.removePlayer(playerId: playerId) { [weak self] result in
            switch result {
            case .success:
                self?.players.removeAll { $0.id == playerId }
                DispatchQueue.main.async {
                    self?.delegate?.reloadTableView()
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPlayer(at index: Int) -> Player? {
        guard index < players.count else { return nil }
        return players[index]
    }
    
    func getPlayerCount() -> Int { players.count }
    
}



