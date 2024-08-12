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
    var player: Player? { get set }
    
    func fetchData()
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerCRUDCellType
    func setSelectedPosition(_ position: String)
    func getSelectedPosition() -> String
    func getPlayerData() -> Player
    func addPlayerToFirebase(completion: @escaping (Result<Void, Error>) -> Void)
    func updatePlayerInFirebase(completion: @escaping (Result<Void, Error>) -> Void)
    func updatePlayerName(_ name: String)
    func updatePlayerGender(_ gender: String)
    func updateSkillPoint(_ skillPoint: Int)
    func updatePlayerAge(_ age: Int)
    func updatePlayerImageData(_ imageData: Data)
    func isFormValid() -> Bool
    func getPositionsForSelectedSport() -> [String]
    
}

final class PlayerCRUDViewModel: PlayerCRUDViewModelProtocol {
    
    // MARK: - Properties
    weak var delegate: (any PlayerCRUDViewControllerProtocol)?
    var player: Player?
    private var playerData = Player()
    
    let playerRepository = NetworkManager.shared.playerRepository
    
    private var imageData: Data?
    private var selectedPosition: String?
    private var sports: [Sport] = []
    private var selectedSport: Sport?
    private var cellTypeList: [PlayerCRUDCellType] = [.playerImage, .playerName, .playerGender, .playerPosition, .playerOtherProperty, .playerAddButton]
    
    // MARK: - Initialization
    init(player: Player? = nil) {
        if let player = player {
            self.player = player
            self.playerData = player
            self.imageData = nil
            self.selectedPosition = player.position
        }
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
    
    func updateSkillPoint(_ skillPoint: Int) {
        playerData.skillRating = Double(skillPoint)
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
    
    func updatePlayerInFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let playerId = player?.id else {
            completion(.failure(NSError(domain: "PlayerIDError", code: 0, userInfo: nil)))
            return
        }
        
        playerRepository.updatePlayer(playerId: playerId,
                                      name: playerData.name,
                                      position: playerData.position,
                                      skillRating: playerData.skillRating,
                                      age: playerData.age,
                                      gender: playerData.gender,
                                      newImageData: imageData) { result in
            completion(result)
        }
    }
    
    func isFormValid() -> Bool {
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
        if imageData == nil || imageData?.isEmpty == true {
            return false
        }
        
        return true
    }
    
    
}
