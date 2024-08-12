//
//  MatchRepository.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation
import FirebaseFirestore


protocol MatchRepositoryProtocol {
    func addMatch(sport: String, playerIDs: [String], location: String, date: Date, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchMatches(sport: String, completion: @escaping (Result<[Match], Error>) -> Void)
    func removeMatch(matchId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class MatchRepository: MatchRepositoryProtocol {
    private let db = Firestore.firestore()

    func addMatch(sport: String, playerIDs: [String], location: String, date: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        // Takım bilgileri uygun şekilde ayarlanmalı
        let teamA = Team(players: playerIDs.prefix(playerIDs.count / 2).map { Player(id: $0) }, sport: sport)
        let teamB = Team(players: playerIDs.suffix(playerIDs.count / 2).map { Player(id: $0) }, sport: sport)
        
        let match = Match(id: UUID().uuidString, sport: sport, teamA: teamA, teamB: teamB, location: location, date: date)
        
        do {
            let _ = try db.collection("matches").addDocument(from: match) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func fetchMatches(sport: String, completion: @escaping (Result<[Match], Error>) -> Void) {
        db.collection("matches").whereField("sport", isEqualTo: sport).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let matches = snapshot?.documents.compactMap { doc -> Match? in
                    try? doc.data(as: Match.self)
                } ?? []
                completion(.success(matches))
            }
        }
    }

    func removeMatch(matchId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("matches").document(matchId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
