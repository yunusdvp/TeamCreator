//
//  EntryViewModel.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

// MARK: - EntryViewModelProtocol
protocol EntryViewModelProtocol: AnyObject {
    var delegate: EntryViewModelDelegate? { get set }

    func fetchSports()
    func load()
    func getSportsCount() -> Int
    func getSport(at index: Int) -> Sport
    func selectSport(at index: Int)
}

// MARK: - EntryViewModelDelegate
protocol EntryViewModelDelegate: AnyObject {
    func reloadCollectionView()
    func navigateToSecond()
}

final class EntryViewModel: EntryViewModelProtocol {

    weak var delegate: EntryViewModelDelegate?
    private var sports: [Sport] = []

    // MARK: - Public Methods
    init(sports: [Sport] = []) {
        self.sports = sports
    }

    func fetchSports() {
        let sports1 = Sport(name: "Football", backgroundImage: "football5", type: .football)
        let sports2 = Sport(name: "Volleyball", backgroundImage: "volleyball", type: .volleyball)
        let sports3 = Sport(name: "Basketball", backgroundImage: "basketball", type: .basketball)
        sports.append(contentsOf: [sports1, sports2, sports3])
        delegate?.reloadCollectionView()
    }

    func getSportsCount() -> Int {
        return sports.count
    }

    func getSport(at index: Int) -> Sport {
        return sports[index]
    }

    func selectSport(at index: Int) {
        SelectedSportManager.shared.selectedSport = sports[index].type
        delegate?.navigateToSecond()
    }

    func load() {
        fetchSports()
    }
}
