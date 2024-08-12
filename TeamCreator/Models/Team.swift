//
//  Team.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 10.08.2024.
//

import Foundation

struct Team {
    var players: [Player]

    var totalSkillRating: Int {
        return Int(players.reduce(0) { $0 + ($1.skillRating ?? 0) })
    }
}
