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

class TeamViewModel {
    
    var onWeatherDataFetched: ((WeatherResponse) -> Void)?
    var onError: ((String) -> Void)?
    var onPlayersUpdated: (([[Players]]) -> Void)?
    
    private(set) var selectedStadium: SportsStadium?
    private(set) var players: [Players] = []
    
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
    
    func loadPlayers() {
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
    }
    
    private func updateFormation() {
        var formation: [[Players]] = []
        
        switch players.count {
        case 4:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...2]),      // Defans (2)
                [players[3]]                // Forvet (1)
            ]
        case 5:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...3]),      // Defans (3)
                [players[4]]                // Forvet (1)
            ]
        case 6:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...2]),      // Defans (2)
                Array(players[3...4]),      // Orta Saha (2)
                [players[5]]                // Forvet (1)
            ]
        case 7:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...3]),      // Defans (3)
                Array(players[4...5]),      // Orta Saha (2)
                [players[6]]                // Forvet (1)
            ]
        case 8:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...3]),      // Defans (3)
                Array(players[4...5]),      // Orta Saha (2)
                Array(players[6...7])       // Forvet (2)
            ]
        case 9:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...3]),      // Defans (3)
                Array(players[4...6]),      // Orta Saha (3)
                Array(players[7...8])       // Forvet (2)
            ]
        case 10:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...4]),      // Defans (4)
                Array(players[5...7]),      // Orta Saha (3)
                Array(players[8...9])       // Forvet (2)
            ]
        case 11:
            formation = [
                [players[0]],               // Kaleci (1)
                Array(players[1...4]),      // Defans (4)
                Array(players[5...7]),      // Orta Saha (3)
                Array(players[8...10])      // Forvet (3)
            ]
        default:
            print("Unsupported team size")
        }
        
        // Formation'ı ViewController'a ilet
        onPlayersUpdated?(formation)
    }
}

