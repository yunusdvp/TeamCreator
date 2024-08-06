//
//  SportsFacilities.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 6.08.2024.
//

import Foundation
struct SportsFacilities: Decodable {
    let stadiums: [Stadium]
    let indoorSportsHalls: [IndoorSportsHall]
}
