//
//  Player.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation

struct Player: Codable {
    var id: String
    var name:String
    var age: Int
    var position: String
    var team: String
    var skillRating: Int
    var gender: Bool
    var profilePhotoURL: String
}
