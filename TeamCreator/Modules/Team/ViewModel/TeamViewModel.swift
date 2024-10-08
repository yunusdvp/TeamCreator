//
//  TeamViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 2.08.2024.
//

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
    var backgroundImageName: String { get }

    func loadInitialData()
    func confirmMatch()
    func fetchStadiumWeather(for stadiumName: String)
    func updateFormation(for sport: String)
    func updateSelectedTeam(index: Int)
    func formattedDate(from date: Date) -> String
    func formattedTime(from date: Date) -> String
}

final class TeamViewModel: TeamViewModelProtocol {
    
    weak var delegate: TeamViewModelDelegate?
    private let matchRepository = NetworkManager.shared.matchRepository
    var players: [Player] = []

    var teamA: Team?
    var teamB: Team?
    var location: String?
    var matchDate: Date?
    
    var backgroundImageName: String {
        switch SelectedSportManager.shared.selectedSport?.rawValue {
        case "football":
            return "soccerField"
        case "basketball":
            return "basketField"
        case "volleyball":
            return "volleyballField"
        default:
            return "defaultField"
        }
    }
    
    init(teamA: Team?, teamB: Team?, location: String?, matchDate: Date?) {
        self.teamA = teamA
        self.teamB = teamB
        self.location = location
        self.matchDate = matchDate
    }
    
    func loadInitialData() {
        updateSelectedTeam(index: 0)
        if let location = location {
            fetchStadiumWeather(for: location)
        }
        if let matchDate = matchDate {
            delegate?.didUpdatePlayers([])
        }
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

    func updateSelectedTeam(index: Int) {
        let selectedTeam = index == 0 ? teamA : teamB
        players = selectedTeam?.players ?? []
        updateFormation(for: selectedTeam?.sport ?? "football")
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

    func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }

    func formattedTime(from date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }
}

