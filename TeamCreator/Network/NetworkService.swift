//
//  NetworkService.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    let playerRepository: PlayerRepository
    let matchRepository: MatchRepository
    let imageStorage: ImageStorage
    let api: API

    private init() {
        self.imageStorage = ImageStorage()
        self.playerRepository = PlayerRepository()
        self.matchRepository = MatchRepository()
        self.api = API.shared
    }

    // Hava durumu verilerini çekmek için yeni fonksiyon
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        api.getWeather(lat: lat, lon: lon, completion: completion)
    }
}
