//
//  PlayerCRUDViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import Foundation

enum PlayerCRUDCellType {
    case playerImage
    case playerName
    case playerGender
    case playerPozition
    case playerAddButton
}

protocol PlayerCRUDViewModelProtocol: AnyObject {
    var delegate: PlayerCRUDViewControllerProtocol? { get set }
    
    func fetchData()
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerCRUDCellType
    func getPositions() -> [String]
    func setSelectedPosition(_ position: String)
    func getSelectedPosition() -> String
}

final class PlayerCRUDViewModel: PlayerCRUDViewModelProtocol {
    weak var delegate: PlayerCRUDViewControllerProtocol?

    private let positions = ["Forward", "Stopper", "Goalkeeper"]
    private var cellTypeList: [PlayerCRUDCellType] = [.playerImage, .playerName, .playerGender, .playerPozition, .playerAddButton]
    private var selectedPosition: String?

    func fetchData() {
        delegate?.reloadTableView()
    }
    
    func getCellTypeCount() -> Int {
        return cellTypeList.count
    }
    
    func getCellType(at index: Int) -> PlayerCRUDCellType {
        return cellTypeList[index]
    }
    
    func getPositions() -> [String] {
        return positions
    }
    
    func getSelectedPosition() -> String {
        return selectedPosition ?? ""
    }
    
    func setSelectedPosition(_ position: String) {
        selectedPosition = position
    }
}
