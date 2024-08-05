//
//  PlayerListViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import Foundation

enum PlayerListCellType {
    case player
    case addButton
}

protocol PlayerListViewModelProtocol: AnyObject {
    var delegate: PlayerListViewControllerProtocol? { get set }
    
    func fetchData()
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerListCellType
}

final class PlayerListViewModel: PlayerListViewModelProtocol {
    
    weak var delegate: PlayerListViewControllerProtocol?
    private var cellTypeList: [PlayerListCellType] = []
    
    init() {
        self.cellTypeList = [.player, .addButton]
    }
    
    func fetchData() {
        //firebase veri çekme fonksiyonu
        delegate?.reloadTableView()
    }
    
    func getCellTypeCount() -> Int {
        return cellTypeList.count
    }
    
    func getCellType(at index: Int) -> PlayerListCellType {
        return cellTypeList[index]
    }
}



