//
//  Match.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation

struct Match: Codable {
    var id: String?
    var sport: String
    var teamA: Team
    var teamB: Team
    var location: String
    var date: Date
}
