//
//  SecondViewModel.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import Foundation

protocol DashboardViewModelProtocol: AnyObject {
    var delegate: DashboardViewModelDelegate? { get set }

    func fetchItems()
    func getItemsCount() -> Int
    func getItem(at index: Int) -> DashboardItem
    func getBackgroundImageName(for category: String) -> String
}

protocol DashboardViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

final class DashboardViewModel: DashboardViewModelProtocol {

    weak var delegate: DashboardViewModelDelegate?
    private var items: [DashboardItem] = []

    init(delegate: DashboardViewModelDelegate) {
        self.delegate = delegate
    }

    func fetchItems() {
        items = [
            DashboardItem(category: "Players", backgroundImage: ""),
            DashboardItem(category: "Create Match", backgroundImage: ""),
            DashboardItem(category: "My Matches", backgroundImage: "myMatches")
        ]
        delegate?.reloadCollectionView()
    }

    func getItemsCount() -> Int {
        return items.count
    }

    func getItem(at index: Int) -> DashboardItem {
        return items[index]
    }
    func getBackgroundImageName(for category: String) -> String {
        guard let selectedSport = SelectedSportManager.shared.selectedSport else { return "" }

        switch selectedSport {
        case .volleyball:
            switch category {
            case "Players":
                return "volleyballPlayer 1"
            case "Create Match":
                return "createVolleyball"
            case "My Matches":
                return "myMatches"
            default:
                return "myMatches"
            }
        case .basketball:
            switch category {
            case "Players":
                return "basketballPlayer"
            case "Create Match":
                return "createBasketball"
            case "My Matches":
                return "myMatches"
            default:
                return "myMatches"
            }
        case .football:
            switch category {
            case "Players":
                return "players"
            case "Create Match":
                return "createMatch"
            case "My Matches":
                return "myMatches"
            default:
                return "myMatches"
            }
        }
    }
}


