//
//  MatchCreateViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 5.08.2024.
//

import Foundation

protocol MatchCreateViewModelProtocol: AnyObject {
    var delegate: MatchCreateViewModelDelegate? { get set }
    var selectedSport: SelectedSport? { get }
    func fetchPlayers(sporType: String, completion: @escaping (Result<[Player], Error>) -> Void)
    func fetchLocations()
    func getPlayersCount() -> Int
    func getPlayer(at index: Int) -> Player
    func getLocationsCount() -> Int
    func getLocationName(at index: Int) -> String
    func getSectionTitle(for section: Int) -> String
    func getNumberOfSections() -> Int
    func getPlayer(at indexPath: IndexPath) -> Player
    func getPlayersCount(for section: Int) -> Int
}

protocol MatchCreateViewModelDelegate: AnyObject {
    func reloadTableView()
    func navigateToAnywhere()
    func updatePickerView()
}
final class MatchCreateViewModel: MatchCreateViewModelProtocol {
    
    

    weak var delegate: MatchCreateViewModelDelegate?
    let playerRepository = NetworkManager.shared.playerRepository
    var selectedSport: SelectedSport? {
        return SelectedSportManager.shared.selectedSport
    }
    
    private var players: [Player] = []
    private var locations: [String] = []
    private var positionSections: [String] = []
    private var groupedPlayers: [String: [Player]] = [:]
    
    
    
    init() {}
    
    func fetchPlayers(sporType: String, completion: @escaping (Result<[Player], Error>) -> Void) {
            let filters: [PlayerFilter] = [.sporType(sporType)]
            playerRepository.fetchPlayers(withFilters: filters) { [weak self] result in
                switch result {
                case .success(let players):
                    self?.players = players
                    self?.groupPlayersByPosition()
                    self?.delegate?.reloadTableView()
                case .failure(let error):
                    print("Error fetching players: \(error.localizedDescription)")
                }
                completion(result)
            }
        }
    
    func fetchLocations() {
            guard let sport = selectedSport else { return }
            loadJsonData { [weak self] stadiums, indoorSportsHalls in
                switch sport {
                case .football:
                    self?.locations = stadiums.map { $0.name ?? "" }
                case .volleyball, .basketball:
                    self?.locations = indoorSportsHalls.map { $0.name ?? "" }
                }
                self?.delegate?.updatePickerView()
            }
        }
    private func loadJsonData(completion: @escaping ([Stadium], [IndoorSportsHall]) -> Void) {
            if let url = Bundle.main.url(forResource: "turkey_sports_facilities", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(SportsFacilities.self, from: data)
                    completion(jsonData.stadiums, jsonData.indoorSportsHalls)
                } catch {
                    print("JSON verileri yüklenemedi: \(error)")
                    completion([], [])
                }
            }
        }
    private func groupPlayersByPosition() {
            groupedPlayers.removeAll()
            guard let selectedSportType = selectedSport else { return }
            
            let positions = getPositionsForSelectedSport(selectedSportType)
            
            for position in positions {
                groupedPlayers[position] = players.filter { $0.position == position }
            }
            
            // Sort the section titles
            positionSections = positions.filter { groupedPlayers[$0]?.isEmpty == false }
        }
        
    func getPositionsForSelectedSport(_ sport: SelectedSport) -> [String] {
            switch sport {
            case .football:
                return ["Forward", "Stopper", "Goalkeeper"]
            case .volleyball:
                return ["Setter", "Outside Hitter", "Libero"]
            case .basketball:
                return ["Point Guard", "Shooting Guard", "Center"]
            }
        }
    
    func getPlayersCount() -> Int {
        return players.count
    }
    
    func getPlayer(at index: Int) -> Player {
        return players[index]
    }
    func getPlayersCount(for section: Int) -> Int {
            let position = positionSections[section]
            return groupedPlayers[position]?.count ?? 0
        }
        
        func getPlayer(at indexPath: IndexPath) -> Player {
            let position = positionSections[indexPath.section]
            return groupedPlayers[position]?[indexPath.row] ?? Player()
        }
    func getNumberOfSections() -> Int {
            return positionSections.count
        }
        
        func getSectionTitle(for section: Int) -> String {
            return positionSections[section]
        }
    
    func getLocationsCount() -> Int {
        return locations.count
    }
        
    func getLocationName(at index: Int) -> String {
        return locations[index]
    }
    
}
