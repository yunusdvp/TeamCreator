//
//  PlayerRepository.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

enum PlayerFilter {
    case minimumSkillRating(Int)
    case ageRange(min: Int, max: Int)
    case gender(String)
    case id(String)
    case sports(String)
    case sporType(String)
}

protocol PlayerRepositoryProtocol {
    func fetchPlayers(withFilters filters: [PlayerFilter], completion: @escaping (Result<[Player], Error>) -> Void)
    func addPlayer(player: Player, imageData: Data, completion: @escaping (Result<Void, Error>) -> Void)

//    func addPlayer(player: Player, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
    func removePlayer(playerId: String, completion: @escaping (Result<Void, Error>) -> Void)
//    func addRandomPlayers(count: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func addRandomPlayers(count: Int, completion: @escaping (Result<Void, Error>) -> Void)

//    func updatePlayer(playerId: String, name: String?, position: String?, skillRating: Int?, age: Int?, gender: String?, newImage: UIImage?, completion: @escaping (Result<Void, Error>) -> Void)
    func updatePlayer(playerId: String, name: String?, position: String?, skillRating: Int?, age: Int?, gender: String?, newImageData: Data?, completion: @escaping (Result<Void, Error>) -> Void)

}

final class PlayerRepository: PlayerRepositoryProtocol {

    private let db = Firestore.firestore()
    private let imageStorage = ImageStorage()
    private var cachedPlayers: [String: [Player]] = [:]

    func fetchPlayers(withFilters filters: [PlayerFilter] = [], completion: @escaping (Result<[Player], Error>) -> Void) {
        var query: Query = db.collection("players")
        var sportTypeFilter: String?

        for filter in filters {
            switch filter {
            case .sports(let sport):
                sportTypeFilter = sport
                query = query.whereField("sport", isEqualTo: sport)
            case .minimumSkillRating(let rating):
                query = query.whereField("skillRating", isGreaterThanOrEqualTo: rating)
            case .ageRange(let min, let max):
                query = query.whereField("age", isGreaterThanOrEqualTo: min).whereField("age", isLessThanOrEqualTo: max)
            case .gender(let gender):
                query = query.whereField("gender", isEqualTo: gender)
            case .id(let id):
                query = query.whereField("id", isEqualTo: id)
            case .sporType(let sporType):
                sportTypeFilter = sporType
                query = query.whereField("sporType", isEqualTo: sporType)
            }
        }

        if let sportType = sportTypeFilter, let cached = cachedPlayers[sportType], !cached.isEmpty {
            print("cache döndü")
            completion(.success(cached))
        } else {
            
            query.getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let players = snapshot?.documents.compactMap { doc -> Player? in
                        try? doc.data(as: Player.self)
                    } ?? []
                    if let sportType = sportTypeFilter {
                        self?.cachedPlayers[sportType] = players
                    }
                    completion(.success(players))
                }
            }
        }
    }

    func addPlayer(player: Player, imageData: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        var player = player
        player.id = UUID().uuidString
        if let image = UIImage(data: imageData), let compressedData = image.jpegData(compressionQuality: 0.33) {
            
            imageStorage.uploadProfileImage(imageData: compressedData) { result in
                switch result {
                case .success(let url):
                    player.profilePhotoURL = url
                    do {
                        let _ = try self.db.collection("players").document(player.id ?? "").setData(from: player) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                self.clearCache()
                                completion(.success(()))
                            }
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(NSError(domain: "ImageCompressionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image compression failed"])))
        }
    }

    

    func removePlayer(playerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("players").document(playerId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.clearCache()
                completion(.success(()))
            }
        }
    }

    func createRandomPlayer() -> Player {
        let sports = ["football": Bool.random(), "volleyball": Bool.random()]
        let genders = ["Male", "Female", "Other"]
        let randomGender = genders.randomElement() ?? "Other"
        return Player(id: UUID().uuidString,
            name: "Player \(Int.random(in: 1...100))",
            age: Int.random(in: 18...40), position: "Position \(Int.random(in: 1...10))",
            gender: randomGender,
            profilePhotoURL: "https://example.com/photo.jpg")
    }
    
    func addRandomPlayers(count: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        var errors: [Error] = []
        let dispatchGroup = DispatchGroup()

        for _ in 0..<count {
            dispatchGroup.enter()
            let player = createRandomPlayer()
            addPlayer(player: player, imageData: UIImage(named: "defaultProfileImage")!.pngData()!) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    errors.append(error)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(()))
            } else {
                completion(.failure(errors.first!))
            }
        }
    }

//    func updatePlayer(playerId: String, name: String?, position: String?, skillRating: Int?, age: Int?, gender: String?, newImage: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
//
//        let playerRef = db.collection("players").document(playerId)
//
//        playerRef.getDocument { document, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let document = document, document.exists else {
//                completion(.failure(NSError(domain: "PlayerNotFoundError", code: 0, userInfo: nil)))
//                return
//            }
//
//            do {
//                var player = try document.data(as: Player.self)
//
//                if let name = name {
//                    player.name = name
//                }
//                if let position = position {
//                    player.position = position
//                }
//                if let skillRating = skillRating {
//                    player.skillRating = skillRating
//                }
//                if let age = age {
//                    player.age = age
//                }
//                if let gender = gender {
//                    player.gender = gender
//                }
//
//                let updatePlayerInFirestore: (String?) -> Void = { imageURL in
//                    if let imageURL = imageURL {
//                        player.profilePhotoURL = imageURL
//                    }
//                    do {
//                        let _ = try playerRef.setData(from: player) { error in
//                            if let error = error {
//                                completion(.failure(error))
//                            } else {
//                                completion(.success(()))
//                            }
//                        }
//                    } catch {
//                        completion(.failure(error))
//                    }
//                }
//
//                if let newImage = newImage {
//                    self.imageStorage.uploadProfileImage(image: newImage) { result in
//                        switch result {
//                        case .success(let url):
//                            updatePlayerInFirestore(url)
//                        case .failure(let error):
//                            completion(.failure(error))
//                        }
//                    }
//                } else {
//                    updatePlayerInFirestore(nil)
//                }
//
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
    func updatePlayer(playerId: String, name: String?, position: String?, skillRating: Int?, age: Int?, gender: String?, newImageData: Data?, completion: @escaping (Result<Void, Error>) -> Void) {

        let playerRef = db.collection("players").document(playerId)

        playerRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "PlayerNotFoundError", code: 0, userInfo: nil)))
                return
            }

            do {
                var player = try document.data(as: Player.self)

                if let name = name {
                    player.name = name
                }
                if let position = position {
                    player.position = position
                }
                if let skillRating = skillRating {
                    player.skillRating = skillRating
                }
                if let age = age {
                    player.age = age
                }
                if let gender = gender {
                    player.gender = gender
                }

                let updatePlayerInFirestore: (String?) -> Void = { imageURL in
                    if let imageURL = imageURL {
                        player.profilePhotoURL = imageURL
                    }
                    do {
                        let _ = try playerRef.setData(from: player) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                self.clearCache()
                                completion(.success(()))
                            }
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }

                if let newImageData = newImageData {
                    self.imageStorage.uploadProfileImage(imageData: newImageData) { result in
                        switch result {
                        case .success(let url):
                            updatePlayerInFirestore(url)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    updatePlayerInFirestore(nil)
                }

            } catch {
                completion(.failure(error))
            }
        }
    }
    private func clearCache() {
            cachedPlayers.removeAll()
        }
    }


