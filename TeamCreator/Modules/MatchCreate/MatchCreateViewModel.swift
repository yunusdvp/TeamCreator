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
    func fetchPlayers()
    func fetchLocations()
    func getPlayersCount() -> Int
    func getPlayer(at index: Int) -> Player
    func getLocationsCount() -> Int
    func getLocationName(at index: Int) -> String
}

protocol MatchCreateViewModelDelegate: AnyObject {
    func reloadTableView()
    func navigateToAnywhere()
    func updatePickerView()
}
final class MatchCreateViewModel: MatchCreateViewModelProtocol {

    weak var delegate: MatchCreateViewModelDelegate?
    
    var selectedSport: SelectedSport? {
        return SelectedSportManager.shared.selectedSport
    }
    
    private var players: [Player] = []
    private var locations: [String] = []
    
    
    init() {}
    
    func fetchPlayers() {
        // Oyuncuları seçilen spora göre getir
        // Örneğin:
        switch selectedSport {
        case .football:
            // Football oyuncularını yükle
            break
        case .volleyball:
            // Volleyball oyuncularını yükle
            break
        case .basketball:
            // Basketball oyuncularını yükle
            break
        case .none:
            break
        }
        delegate?.reloadTableView()
    }
    
    func fetchLocations() {
            // JSON'dan lokasyonları seçilen spora göre yükle
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
            // JSON dosyasını proje içerisinden yükleme ve parse etme işlemi
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
    
    func getPlayersCount() -> Int {
        return players.count
    }
    
    func getPlayer(at index: Int) -> Player {
        return players[index]
    }
    
    func getLocationsCount() -> Int {
        return locations.count
    }
        
    func getLocationName(at index: Int) -> String {
        return locations[index]
    }
}
