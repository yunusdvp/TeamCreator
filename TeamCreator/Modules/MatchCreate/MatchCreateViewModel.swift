//
//  MatchCreateViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 5.08.2024.
//

import Foundation

protocol MatchCreateViewModelProtocol: AnyObject {
    var delegate: MatchCreateViewModelDelegate? { get set }
    var selectedSport: SelectedSport? { get }
    func fetchPlayers(sporType: String, completion: @escaping (Result<[Player], Error>) -> Void)
    func fetchLocations()
    func getPlayersCount() -> Int
    func getPlayer(at index: Int) -> Player
    func getLocationsCount() -> Int
    func getLocationName(at index: Int) -> String
    func getSectionTitle(for section: Int) -> String
    func getNumberOfSections() -> Int
    func getPlayer(at indexPath: IndexPath) -> Player
    func getPlayersCount(for section: Int) -> Int
    func createBalancedTeams(from players: [Player], sportName: String) -> (teamA: Team, teamB: Team)?
    func calculateTeamScore(for team: Team) -> Double
    func setSportCriteria(for sportName: String)
}

protocol MatchCreateViewModelDelegate: AnyObject {
    func reloadTableView()
    func navigateToAnywhere()
    func updatePickerView()

}
final class MatchCreateViewModel: MatchCreateViewModelProtocol {

    let footballCriteria = TeamBalancingCriteria(skillWeight: 0.4, ageWeight: 0.2, positionWeight: 0.3, genderWeight: 0.1)
    let volleyballCriteria = TeamBalancingCriteria(skillWeight: 0.3, ageWeight: 0.2, positionWeight: 0.4, genderWeight: 0.1)
    let basketballCriteria = TeamBalancingCriteria(skillWeight: 0.4, ageWeight: 0.2, positionWeight: 0.3, genderWeight: 0.1)


    weak var delegate: MatchCreateViewModelDelegate?
    let playerRepository = NetworkManager.shared.playerRepository
    var selectedSport: SelectedSport? {
        return SelectedSportManager.shared.selectedSport
    }

    private var players: [Player] = []
    private var criteria: TeamBalancingCriteria?
    private var locations: [String] = []
    private var positionSections: [String] = []
    private var groupedPlayers: [String: [Player]] = [:]



    init() { }

    func fetchPlayers(sporType: String, completion: @escaping (Result<[Player], Error>) -> Void) {
        let filters: [PlayerFilter] = [.sporType(sporType)]
        playerRepository.fetchPlayers(withFilters: filters) { [weak self] result in
            switch result {
            case .success(let players):
                self?.players = players
                self?.groupPlayersByPosition()
                self?.delegate?.reloadTableView()
            case .failure(let error):
                print("Error fetching players: \(error.localizedDescription)")
            }
            completion(result)
        }
    }

    func fetchLocations() {
        guard let sport = selectedSport else { return }
        loadJsonData { [weak self] stadiums, indoorSportsHalls in
            switch sport {
            case .football:
                self?.locations = stadiums.map { $0.name ?? "" }
            case .volleyball, .basketball:
                self?.locations = indoorSportsHalls.map { $0.name ?? "" }
            }
            self?.delegate?.updatePickerView()
        }
    }
    func calculatePlayerScore(player: Player, criteria: TeamBalancingCriteria) -> Double {
        let skillScore = Double(player.skillRating ?? 0) * criteria.skillWeight
        let ageScore = calculateAgeScore(age: player.age, sportName: player.sporType) * criteria.ageWeight
        let positionScore = calculatePositionScore(position: player.position, sportName: player.sporType) * criteria.positionWeight
        let genderScore = calculateGenderScore(gender: player.gender) * criteria.genderWeight

        return skillScore + ageScore + positionScore + genderScore
    }
    
    func calculateTeamScore(for team: Team) -> Double {
        guard let criteria = criteria else {
            print("Criteria tanımlı değil")
            return 0
        }

        // Takımda pozisyon dengesizliğini kontrol et
        let idealPositions = getIdealPositions(for: selectedSport)
        let positionCounts = getPositionCounts(for: team)

        var totalScore = 0.0
        for player in team.players {
            var playerScore = calculatePlayerScore(player: player, criteria: criteria)
            let position = player.position?.lowercased()

            if let requiredCount = idealPositions[position ?? ""] {
                let currentCount = positionCounts[position ?? ""] ?? 0
                
                // Pozisyon dengesizliği varsa, puanı düşür
                if currentCount > requiredCount {
                    playerScore *= 0.5 // Fazla oyuncu varsa, puanı yarıya düşürüyoruz
                } else if currentCount < requiredCount {
                    playerScore *= 0.67 // Eksik oyuncu varsa, puanı 2/3'e düşürüyoruz
                }
            }

            totalScore += playerScore
        }

        return totalScore
    }

    func getIdealPositions(for sport: SelectedSport?) -> [String: Int] {
        switch sport {
        case .football:
            return ["goalkeeper": 1, "stopper": 2, "forward": 2]
        case .volleyball:
            return ["setter": 1, "outside hitter": 2, "libero": 1]
        case .basketball:
            return ["point guard": 1, "shooting guard": 1, "center": 1]
        default:
            return [:]
        }
    }

    func getPositionCounts(for team: Team) -> [String: Int] {
        var positionCounts: [String: Int] = [:]
        for player in team.players {
            let position = player.position?.lowercased() ?? ""
            positionCounts[position, default: 0] += 1
        }
        return positionCounts
    }


    func calculateAgeScore(age: Int?, sportName: String?) -> Double {
        guard let age = age, let sportName = sportName else { return 0.0 }

        switch sportName.lowercased() {
        case "football":
            return Double(30 - age)
        case "volleyball":
            return Double(28 - age)
        case "basketball":
            return Double(32 - age)
        default:
            return 0.0
        }
    }

    func calculatePositionScore(position: String?, sportName: String?) -> Double {
        guard let position = position, let sportName = sportName else { return 0.0 }

        switch sportName.lowercased() {
        case "football":
            return footballPositionScore(position: position)
        case "volleyball":
            return volleyballPositionScore(position: position)
        case "basketball":
            return basketballPositionScore(position: position)
        default:
            return 0.0
        }
    }

    func calculateGenderScore(gender: String?) -> Double {
        return gender?.lowercased() == "male" ? 1.0 : 0.9
    }
    func footballPositionScore(position: String) -> Double {
        switch position.lowercased() {
        case "forward": return 1.0
        case "stopper": return 0.8
        case "goalkeeper": return 0.6
        default: return 0.5
        }
    }

    func volleyballPositionScore(position: String) -> Double {
        switch position.lowercased() {
        case "setter": return 1.0
        case "outside hitter": return 0.8
        case "libero": return 0.6
        default: return 0.5
        }
    }

    func basketballPositionScore(position: String) -> Double {
        switch position.lowercased() {
        case "point guard": return 1.0
        case "shooting guard": return 0.8
        case "center": return 0.6
        default: return 0.5
        }
    }
    func setSportCriteria(for sportName: String) {
        switch sportName.lowercased() {
        case "football":
            self.criteria = footballCriteria
        case "volleyball":
            self.criteria = volleyballCriteria
        case "basketball":
            self.criteria = basketballCriteria
        default:
            fatalError("Geçersiz spor adı")
        }
    }

    func createBalancedTeams(from players: [Player], sportName: String) -> (teamA: Team, teamB: Team)? {
        guard players.count >= 2 else {
            return nil // Yeterli oyuncu yoksa
        }

        // Spor türüne göre kriterleri ayarla
        setSportCriteria(for: sportName)
        
        // Oyuncuları pozisyonlarına göre gruplandır
        let groupedByPosition = Dictionary(grouping: players) { $0.position?.lowercased() ?? "" }

        var teamA = Team(players: [])
        var teamB = Team(players: [])

        // Pozisyon gruplarını sırayla her iki takıma dağıt
        for (position, playersInPosition) in groupedByPosition {
            // Puanlarına göre sırala
            let sortedPlayers = playersInPosition.sorted { calculatePlayerScore(player: $0, criteria: criteria!) > calculatePlayerScore(player: $1, criteria: criteria!) }

            for (index, player) in sortedPlayers.enumerated() {
                if index % 2 == 0 {
                    teamA.players.append(player)
                } else {
                    teamB.players.append(player)
                }
            }
        }

        // Takımların toplam puanlarını hesapla
        let teamAScore = calculateTeamScore(for: teamA)
        let teamBScore = calculateTeamScore(for: teamB)

        print("Team A Total Score: \(teamAScore)")
        print("Team B Total Score: \(teamBScore)")

        return (teamA, teamB)
    }






    private func loadJsonData(completion: @escaping ([Stadium], [IndoorSportsHall]) -> Void) {
        if let url = Bundle.main.url(forResource: "turkey_sports_facilities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(SportsFacilities.self, from: data)
                completion(jsonData.stadiums, jsonData.indoorSportsHalls)
            } catch {
                print("JSON verileri yüklenemedi: \(error)")
                completion([], [])
            }
        }
    }
    private func groupPlayersByPosition() {
        groupedPlayers.removeAll()
        guard let selectedSportType = selectedSport else { return }

        let positions = getPositionsForSelectedSport(selectedSportType)

        for position in positions {
            groupedPlayers[position] = players.filter { $0.position == position }
        }

        // Sort the section titles
        positionSections = positions.filter { groupedPlayers[$0]?.isEmpty == false }
    }

    func getPositionsForSelectedSport(_ sport: SelectedSport) -> [String] {
        switch sport {
        case .football:
            return ["Forward", "Stopper", "Goalkeeper"]
        case .volleyball:
            return ["Setter", "Outside Hitter", "Libero"]
        case .basketball:
            return ["Point Guard", "Shooting Guard", "Center"]
        }
    }

    func getPlayersCount() -> Int {
        return players.count
    }

    func getPlayer(at index: Int) -> Player {
        return players[index]
    }
    func getPlayersCount(for section: Int) -> Int {
        let position = positionSections[section]
        return groupedPlayers[position]?.count ?? 0
    }

    func getPlayer(at indexPath: IndexPath) -> Player {
        let position = positionSections[indexPath.section]
        return groupedPlayers[position]?[indexPath.row] ?? Player()
    }
    func getNumberOfSections() -> Int {
        return positionSections.count
    }

    func getSectionTitle(for section: Int) -> String {
        return positionSections[section]
    }

    func getLocationsCount() -> Int {
        return locations.count
    }

    func getLocationName(at index: Int) -> String {
        return locations[index]
    }

}
