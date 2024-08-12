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
    func navigateToTeam(teamA: Team?,teamB: Team?, location: String?, matchDate: Date?)
    func updatePickerView()

}
final class MatchCreateViewModel: MatchCreateViewModelProtocol {

    let footballCriteria = TeamBalancingCriteria(skillWeight: 1.0)
    let volleyballCriteria = TeamBalancingCriteria(skillWeight: 1.0)
    let basketballCriteria = TeamBalancingCriteria(skillWeight: 1.0)


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
    func adjustSkillPoints(for sportName: String) {
        players = players.map { player in
            var updatedPlayer = player

            // Yaş bazlı düşürme
            if let age = player.age, age < 20 || age > 32 {
                let ageDifference = max(abs(30 - age) / 5, 1)
                updatedPlayer.skillRating = player.skillRating.map { $0 * pow(0.9, Double(ageDifference)) }
            }

            if let gender = player.gender?.lowercased() {
                switch sportName.lowercased() {
                case "football", "basketball":
                    if gender == "male" {
                        updatedPlayer.skillRating = player.skillRating.map { $0 * 1.1 }
                    }
                case "volleyball":
                    if gender == "female" {
                        updatedPlayer.skillRating = player.skillRating.map { $0 * 1.1 }
                    }
                default:
                    break
                }
            }

            return updatedPlayer
        }
    }

    /*func calculatePlayerScore(player: Player, criteria: TeamBalancingCriteria) -> Double {
        let skillScore = Double(player.skillRating ?? 0) * criteria.skillWeight
        let ageScore = calculateAgeScore(age: player.age, sportName: player.sporType) * criteria.ageWeight
        let positionScore = calculatePositionScore(position: player.position, sportName: player.sporType) * criteria.positionWeight
        let genderScore = calculateGenderScore(gender: player.gender) * criteria.genderWeight

        return skillScore + ageScore + positionScore + genderScore
    }*/
    
    func calculateTeamScore(for team: Team) -> Double {
            var totalScore = 0.0
            for player in team.players {
                totalScore += Double(player.skillRating ?? 0)
            }
            return totalScore
        }
    func optimizeTeams(_ teamA: inout Team, _ teamB: inout Team) {
        var optimized = false
        while !optimized {
            optimized = true
            for playerIndexA in 0..<teamA.players.count {
                for playerIndexB in 0..<teamB.players.count {
                    // Oyuncuları değiştir ve takımların yeni puanlarını hesapla
                    var newTeamAPlayers = teamA.players
                    var newTeamBPlayers = teamB.players
                    let tempPlayer = newTeamAPlayers[playerIndexA]

                    newTeamAPlayers[playerIndexA] = newTeamBPlayers[playerIndexB]
                    newTeamBPlayers[playerIndexB] = tempPlayer

                    let newTeamAScore = calculateTeamScore(for: Team(players: newTeamAPlayers))
                    let newTeamBScore = calculateTeamScore(for: Team(players: newTeamBPlayers))

                    if abs(newTeamAScore - newTeamBScore) < abs(calculateTeamScore(for: teamA) - calculateTeamScore(for: teamB)) {
                        teamA.players = newTeamAPlayers
                        teamB.players = newTeamBPlayers
                        optimized = false
                    }
                }
            }
        }
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
            guard players.count >= 4 else {
                return nil
            }

            setSportCriteria(for: sportName)

            var teamA = Team(players: [])
            var teamB = Team(players: [])
            let sortedPlayers = players.sorted { $0.skillRating ?? 0 > $1.skillRating ?? 0 }

            for (index, player) in sortedPlayers.enumerated() {
                if index % 2 == 0 {
                    teamA.players.append(player)
                } else {
                    teamB.players.append(player)
                }
            }
        
            var teamAScore = calculateTeamScore(for: teamA)
            var teamBScore = calculateTeamScore(for: teamB)

            if abs(teamAScore - teamBScore) > 10 {
                optimizeTeams(&teamA, &teamB)
                teamAScore = calculateTeamScore(for: teamA)
                teamBScore = calculateTeamScore(for: teamB)
            }

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
