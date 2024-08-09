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
    
    //func fetchData()
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerListCellType
    func getPlayer(at index: Int) -> Player?
    func getPlayerCount() -> Int
}

final class PlayerListViewModel: PlayerListViewModelProtocol {
    
    
    weak var delegate: PlayerListViewControllerProtocol?
    private var cellTypeList: [PlayerListCellType] = []
    private var players: [Player] = []
    
    let playerRepository = NetworkManager.shared.playerRepository
    let imageStorage = NetworkManager.shared.imageStorage
    let db = Firestore.firestore()
    
    init() {
        self.cellTypeList = [.player, .addButton]
    }
    
    
    func fetchPlayers(sporType: String, completion: @escaping (Result<[Player], Error>) -> Void) {
            let filters: [PlayerFilter] = [.sporType(sporType)]
            playerRepository.fetchPlayers(withFilters: filters) { [weak self] result in
                switch result {
                case .success(let players):
                    self?.players = players
                    self?.delegate?.reloadTableView()
                case .failure(let error):
                    print("Error fetching players: \(error.localizedDescription)")
                }
                completion(result)
            }
        }
        //delegate?.reloadTableView()
    
    func getCellTypeCount() -> Int {
        return cellTypeList.count
    }
    
    func getCellType(at index: Int) -> PlayerListCellType {
        return cellTypeList[index]
    }
    
    func getPlayer(at index: Int) -> Player? {
            guard index < players.count else { return nil }
            return players[index]
        }
        
    func getPlayerCount() -> Int { players.count }
    
}



