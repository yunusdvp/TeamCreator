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
    func reloadTableView()
    func showUpdateAlert(success: Bool, message: String)
    func updatePlayerList()
    func presentImagePicker()
}

protocol PlayerCRUDViewModelProtocol: AnyObject {
    var delegate: PlayerCRUDViewModelDelegate? { get set }
    var player: Player? { get set }

    func fetchData()
    func getCellTypeCount() -> Int
    func getCellType(at index: Int) -> PlayerCRUDCellType
    func setSelectedPosition(_ position: String)
    func getSelectedPosition() -> String
    func updatePlayerName(_ name: String)
    func updatePlayerGender(_ gender: String)
    func updateSkillPoint(_ skillPoint: Int)
    func updatePlayerAge(_ age: Int)
    func updatePlayerImageData(_ imageData: Data)
    func addOrUpdatePlayer()
    func isFormValid() -> Bool
    func getPositionsForSelectedSport() -> [String]

}

final class PlayerCRUDViewModel: PlayerCRUDViewModelProtocol {

    // MARK: - Properties
    weak var delegate: PlayerCRUDViewModelDelegate?
    var player: Player?
    private var playerData = Player()

    private let playerRepository = NetworkManager.shared.playerRepository

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
            self.selectedPosition = player.position
        }
    }
    func fetchData() { delegate?.reloadTableView() }

    func updatePlayerName(_ name: String) { playerData.name = name }

    func updatePlayerGender(_ gender: String) { playerData.gender = gender }

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

    func updateSkillPoint(_ skillPoint: Int) { playerData.skillRating = Double(skillPoint) }

    func updatePlayerAge(_ age: Int) { playerData.age = age }

    func getCellTypeCount() -> Int { cellTypeList.count }

    func getCellType(at index: Int) -> PlayerCRUDCellType { cellTypeList[index] }

    func getSelectedPosition() -> String { selectedPosition ?? "" }


    func updatePlayerImageData(_ imageData: Data) { self.imageData = imageData }

    private func addPlayerToFirebase() {
        guard let imageData = imageData else {
            delegate?.showUpdateAlert(success: false, message: "Image data is missing.")
            return
        }

        playerRepository.addPlayer(player: playerData, imageData: imageData) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.showUpdateAlert(success: true, message: "Player successfully added.")
                self?.delegate?.updatePlayerList()
            case .failure(let error):
                self?.delegate?.showUpdateAlert(success: false, message: "Failed to add player: \(error.localizedDescription)")
            }
        }
    }
    private func setSelectedSport(_ sport: SelectedSport) { playerData.sporType = sport.rawValue }

    private func updatePlayerInFirebase() {
        guard let playerId = player?.id else {
            delegate?.showUpdateAlert(success: false, message: "Player ID is missing.")
            return
        }

        let imageDataToUpdate = imageData ?? Data()

        playerRepository.updatePlayer(playerId: playerId,
            name: playerData.name,
            position: playerData.position,
            skillRating: playerData.skillRating,
            age: playerData.age,
            gender: playerData.gender,
                newImageData: imageDataToUpdate.isEmpty ? nil : imageDataToUpdate) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.showUpdateAlert(success: true, message: "Player successfully updated.")
                self?.delegate?.updatePlayerList()
            case .failure(let error):
                self?.delegate?.showUpdateAlert(success: false, message: "Failed to update player: \(error.localizedDescription)")
            }
        }
    }

    func setSelectedPosition(_ position: String) {
        selectedPosition = position
        playerData.position = position
    }

    func addOrUpdatePlayer() {
        guard isFormValid() else {
            return
        }

        if player != nil {
            updatePlayerInFirebase()
        } else {
            addPlayerToFirebase()
        }
    }

    func isFormValid() -> Bool {
        guard playerData.name?.isEmpty == false,
            playerData.age != nil,
            playerData.position?.isEmpty == false,
            playerData.skillRating != nil,
            playerData.gender?.isEmpty == false,
            imageData != nil || player?.profilePhotoURL != nil else {
            return false
        }
        return true
    }


}
