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

    private init() {
        self.imageStorage = ImageStorage()
        self.playerRepository = PlayerRepository()
        self.matchRepository = MatchRepository()
    }
}
