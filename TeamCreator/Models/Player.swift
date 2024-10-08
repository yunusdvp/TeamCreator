//
//  Player.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation

struct Player: Codable {
    var id: String?
    var name: String?
    var age: Int?
    var position: String?
    var sporType: String?
    var skillRating: Double?
    var gender: String?
    var profilePhotoURL: String?
}

struct PlayerScore {
    var player: Player
    var score: Double
}
