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
    func fetchPlayers(completion: @escaping (Result<[Player], Error>) -> Void)
    
    //func fetchData()
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerListCellType
}

final class PlayerListViewModel: PlayerListViewModelProtocol {
    
    weak var delegate: PlayerListViewControllerProtocol?
    private var cellTypeList: [PlayerListCellType] = []
    
    let playerRepository = NetworkManager.shared.playerRepository
    let imageStorage = NetworkManager.shared.imageStorage
    let db = Firestore.firestore()
    
    init() {
        self.cellTypeList = [.player, .addButton]
    }
    
    
        func fetchPlayers(completion: @escaping (Result<[Player], Error>) -> Void) {
                let query: Query = db.collection("players")
                
                query.getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        let players = snapshot?.documents.compactMap { doc -> Player? in
                            try? doc.data(as: Player.self)
                        } ?? []
                        completion(.success(players))
                    }
                }
            }
        //delegate?.reloadTableView()
    
    func getCellTypeCount() -> Int {
        return cellTypeList.count
    }
    
    func getCellType(at index: Int) -> PlayerListCellType {
        return cellTypeList[index]
    }
}



