//
//  TeamViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 2.08.2024.
//

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



