//
//  Match.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

/*
import Foundation

struct Match: Codable {
    var id: String?
    var sport: String
    var teamA: Team
    var teamB: Team
    var location: String
    var date: Date
}
*/

import Foundation

struct Match: Codable {
    var id: String?
    var sport: String
    var teamA: Team
    var teamB: Team
    var location: String
    var date: Date
    
    // Yardımcı Özellikler
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self.date)
    }
    
    var hourFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self.date)
    }
    
    var sportImageName: String {
        return "\(self.sport)_icon"
    }
}

