//
//  Player.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation


struct Player: Codable {
    let id: String
    let name:String
    let age: Int
    let position: String
    let team: String
    let skillRating: Int
    let gender: Bool
    let profilePhotoUrl: String
    
}
