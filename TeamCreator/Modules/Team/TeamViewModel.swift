//
//  TeamViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 2.08.2024.
//
/*
import Foundation

class TeamViewModel {

    var onWeatherDataFetched: ((WeatherResponse) -> Void)?
    var onError: ((String) -> Void)?

    private(set) var selectedStadium: SportsStadium?

    func fetchStadiumWeather(for stadiumName: String) {
        if let path = Bundle.main.path(forResource: "turkey_sports_facilities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let facilities = try JSONDecoder().decode(TurkeySportsFacilities.self, from: data)
                
                if let stadium = facilities.stadiums.first(where: { $0.name == stadiumName }) {
                    selectedStadium = stadium
                    fetchWeatherData(for: stadium.latitude, lon: stadium.longitude)
                } else {
                    onError?("Stadium not found")
                }
            } catch {
                onError?("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    }

    private func fetchWeatherData(for lat: Double, lon: Double) {
        NetworkManager.shared.fetchWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                self?.onWeatherDataFetched?(weatherResponse)
            case .failure(let error):
                self?.onError?("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
}
*/

import Foundation

protocol TeamViewModelDelegate: AnyObject {
    func didFetchWeatherData(_ weatherResponse: WeatherResponse)
    func didFailWithError(_ error: String)
    func didUpdatePlayers(_ formation: [[Player]])
    func didCreateMatchSuccessfully()
    func didFailToCreateMatch(_ error: String)
    
}
protocol TeamViewModelProtocol: AnyObject {
    var delegate: TeamViewModelDelegate? { get set }
    var teamA: Team? { get set }
    var teamB: Team? { get set }
    var location: String? { get set }
    var matchDate: Date? { get set }
    var players: [Player] { get set }

    func confirmMatch()
    func fetchStadiumWeather(for stadiumName: String)
    func updateFormation(for sport: String)
}


final class TeamViewModel: TeamViewModelProtocol {
    
    weak var delegate: TeamViewModelDelegate?
    
    private let matchRepository = NetworkManager.shared.matchRepository

    var onWeatherDataFetched: ((WeatherResponse) -> Void)?
    var onError: ((String) -> Void)?
    var onPlayersUpdated: (([[Player]]) -> Void)?

    private(set) var selectedStadium: Stadium?
    private(set) var selectedIndoorSportsHall: IndoorSportsHall?
    var players: [Player] = []

    var teamA: Team?
    var teamB: Team?
    var location: String?
    var matchDate: Date?

    init(teamA: Team?, teamB: Team?, location: String?, matchDate: Date?) {
        self.teamA = teamA
        self.teamB = teamB
        self.location = location
        self.matchDate = matchDate
        print(teamA as Any)
        print(teamB as Any)
        print(location as Any)
        print(matchDate as Any)
    }

    init() {

    }
    
    func confirmMatch() {
            guard let teamA = teamA, let teamB = teamB, let location = location, let matchDate = matchDate else {
                delegate?.didFailToCreateMatch("Missing match details")
                return
            }

            matchRepository.addMatch(sport: teamA.sport, playerIDs: teamA.players.map { $0.id! } + teamB.players.map { $0.id! }, location: location, date: matchDate) { [weak self] result in
                switch result {
                case .success:
                    self?.delegate?.didCreateMatchSuccessfully()
                case .failure(let error):
                    self?.delegate?.didFailToCreateMatch("Failed to create match: \(error.localizedDescription)")
                }
            }
        }

    func fetchStadiumWeather(for stadiumName: String) {
            guard let path = Bundle.main.path(forResource: "turkey_sports_facilities", ofType: "json") else {
                delegate?.didFailWithError("File not found")
                return
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let facilities = try JSONDecoder().decode(SportsFacilities.self, from: data)
                if let stadium = facilities.stadiums.first(where: { $0.name == location }) {
                    fetchWeatherData(for: stadium.coordinates?.latitude ?? 0, lon: stadium.coordinates?.longitude ?? 0)
                } else if let indoorHall = facilities.indoorSportsHalls.first(where: { $0.name == location }) {
                    fetchWeatherData(for: indoorHall.coordinates?.latitude ?? 0, lon: indoorHall.coordinates?.longitude ?? 0)
                } else {
                    delegate?.didFailWithError("Stadium not found")
                }
            } catch {
                delegate?.didFailWithError("Error parsing JSON: \(error.localizedDescription)")
            }
        }

    private func fetchWeatherData(for lat: Double, lon: Double) {
        NetworkManager.shared.fetchWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                self?.delegate?.didFetchWeatherData(weatherResponse)
            case .failure(let error):
                self?.delegate?.didFailWithError("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }

    func updateFormation(for sport: String) {
        var formation: [[Player]] = []

        let positions = getPositions(for: sport)

        for position in positions {
            let playersInPosition = players.filter { $0.position == position }
            formation.append(playersInPosition)
        }


        delegate?.didUpdatePlayers(formation)
    }
    private func getPositions(for sport: String) -> [String] {
        switch sport.lowercased() {
        case "football":
            return ["Goalkeeper", "Stopper", "Forward"]
        case "volleyball":
            return ["Setter", "Outside Hitter", "Libero"]
        case "basketball":
            return ["Point Guard", "Shooting Guard", "Center"]
        default:
            return []
        }
    }
}

/*func loadPlayers() {
    // Örnek oyuncular
    players = [
        Players(name: "Ali"),
        Players(name: "Ayşe"),
        Players(name: "Mehmet"),
        Players(name: "Fatma"),
        Players(name: "Giray"),
        Players(name: "Ceren"),
        Players(name: "Yunus"),
        Players(name: "Gizem"),
        Players(name: "Canan"),
        Players(name: "Mustafa"),

    ]
    updateFormation()
}*/
