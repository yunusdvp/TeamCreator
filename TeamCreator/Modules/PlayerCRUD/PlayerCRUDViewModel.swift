//
//  PlayerCRUDViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import Foundation

// MARK: - Enums
enum PlayerCRUDCellType {
    case playerImage
    case playerName
    case playerGender
    case playerPosition
    case playerOtherProperty
    case playerAddButton
}

// MARK: - Protocols
protocol PlayerCRUDViewModelDelegate: AnyObject {
    func fetchData()
}

protocol PlayerCRUDViewModelProtocol: AnyObject {
    var delegate: PlayerCRUDViewControllerProtocol? { get set }
    
    func fetchData()
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerCRUDCellType
    func setSelectedPosition(_ position: String)
    func getSelectedPosition() -> String
    func updatePlayerName(_ name: String)
    func updatePlayerGender(_ gender: String)
    func updateSkillPoint(_ skillPoint: Int)
    func updatePlayerAge(_ age: Int)
    func getPlayerData() -> Player
    func updatePlayerImageData(_ imageData: Data)
    func addPlayerToFirebase(completion: @escaping (Result<Void, Error>) -> Void)
    func isFormValid() -> Bool
    func getPositionsForSelectedSport() -> [String]
}

final class PlayerCRUDViewModel: PlayerCRUDViewModelProtocol {
    // MARK: - Properties
    var delegate: (any PlayerCRUDViewControllerProtocol)?
    
    private var playerData = Player()
    private let playerRepository: PlayerRepositoryProtocol
    private var imageData: Data?
    private var cellTypeList: [PlayerCRUDCellType] = [.playerImage, .playerName, .playerGender, .playerPosition, .playerOtherProperty, .playerAddButton]
    private var selectedPosition: String?
    
    private var sports: [Sport] = []
    private var selectedSport: Sport?
    
    
    
    // MARK: - Initialization
    init(playerRepository: PlayerRepositoryProtocol = PlayerRepository()) {
        self.playerRepository = playerRepository
    }
    func updatePlayerName(_ name: String) {
        playerData.name = name
    }
    
    func updatePlayerGender(_ gender: String) {
        playerData.gender = gender
    }

    func getPositionsForSelectedSport() -> [String] {
        guard let selectedSportType = SelectedSportManager.shared.selectedSport else {
            return []
        }
        
        setSelectedSport(selectedSportType)
        
        switch selectedSportType {
        case .football:
            return ["Forward", "Stopper", "Goalkeeper"]
        case .volleyball:
            return ["Setter", "Outside Hitter", "Libero"]
        case .basketball:
            return ["Point Guard", "Shooting Guard", "Center"]
        }
    }


    func setSelectedSport(_ sport: SelectedSport) {
        playerData.sporType = sport.rawValue
    }
    
    func updateSkillPoint(_ skillPoint: Int)   {
        playerData.skillRating = skillPoint
    }
    
    func updatePlayerAge(_ age: Int) {
        playerData.age = age
    }
    
    func getPlayerData() -> Player {
        return playerData
    }
    
    func fetchData() {
        delegate?.reloadTableView()
    }
    
    func getCellTypeCount() -> Int {
        return cellTypeList.count
    }
    
    func getCellType(at index: Int) -> PlayerCRUDCellType {
        return cellTypeList[index]
    }
    
    func getSelectedPosition() -> String {
        return selectedPosition ?? ""
    }
    
    func setSelectedPosition(_ position: String) {
        selectedPosition = position
        playerData.position = position
    }
    
    func updatePlayerImageData(_ imageData: Data) {
        self.imageData = imageData
    }
    
    
    func addPlayerToFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageData = imageData else {
            print("Image data not provided")
            playerRepository.addPlayer(player: playerData, imageData: Data()) { result in
                completion(result)
            }
            return
        }
        playerRepository.addPlayer(player: playerData, imageData: imageData) { result in
            completion(result)
        }
    }
    func isFormValid() -> Bool {
        
        //        guard let photoURLString = playerData.profilePhotoURL, !photoURLString.isEmpty, let _ = URL(string: photoURLString) else {
        //                return false
        //            }
        if playerData.name?.isEmpty == true {
            return false
        }
        if playerData.age == nil {
            return false
        }
        if playerData.position?.isEmpty == true {
            return false
        }
        if playerData.skillRating == nil {
            return false
        }
        if playerData.gender?.isEmpty == true {
            return false
        }
        
        return true
    }

}
