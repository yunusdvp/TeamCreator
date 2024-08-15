//
//  DashboardViewModelsTests.swift
//  TeamCreatorTests
//
//  Created by Yunus Emre ÖZŞAHİN on 13.08.2024.
//

import XCTest
@testable import TeamCreator

class MockDashboardViewModelDelegate: DashboardViewModelDelegate {
    var didCallReloadCollectionView = false

    func reloadCollectionView() {
        didCallReloadCollectionView = true
    }
}

final class DashboardViewModelsTests: XCTestCase {

    var viewModel: DashboardViewModel!
       var mockDelegate: MockDashboardViewModelDelegate!

       override func setUp() {
           super.setUp()
           mockDelegate = MockDashboardViewModelDelegate()
           viewModel = DashboardViewModel()
           viewModel.delegate = mockDelegate
       }

       override func tearDown() {
           viewModel = nil
           mockDelegate = nil
           super.tearDown()
       }

       func testFetchItems() {

           XCTAssertEqual(viewModel.getItemsCount(), 0, "Initial items count should be 0")

           viewModel.fetchItems()

           XCTAssertEqual(viewModel.getItemsCount(), 3, "Items count should be 3 after fetching items")
           XCTAssertTrue(mockDelegate.didCallReloadCollectionView, "reloadCollectionView should be called after fetching items")
       }

       func testGetItemAtIndex() {
           viewModel.fetchItems()

           let item = viewModel.getItem(at: 1)

           XCTAssertEqual(item.category, "Create Match", "The item category at index 1 should be 'Create Match'")
       }

       func testGetBackgroundImageNameForCategoryFootball() {
           SelectedSportManager.shared.selectedSport = .football

           let backgroundImageName = viewModel.getBackgroundImageName(for: "Players")

           XCTAssertEqual(backgroundImageName, "footballPlayers", "The background image for 'Players' in football should be 'footballPlayers'")
       }

       func testGetBackgroundImageNameForCategoryBasketball() {

           SelectedSportManager.shared.selectedSport = .basketball

           let backgroundImageName = viewModel.getBackgroundImageName(for: "Create Match")

           XCTAssertEqual(backgroundImageName, "createBasketball", "The background image for 'Create Match' in basketball should be 'createBasketball'")
       }

       func testGetBackgroundImageNameForCategoryVolleyball() {

           SelectedSportManager.shared.selectedSport = .volleyball

           let backgroundImageName = viewModel.getBackgroundImageName(for: "My Matches")

           XCTAssertEqual(backgroundImageName, "myMatches", "The background image for 'My Matches' in volleyball should be 'myMatches'")
       }

       func testGetBackgroundImageNameForUnknownCategory() {

           SelectedSportManager.shared.selectedSport = .volleyball

           let backgroundImageName = viewModel.getBackgroundImageName(for: "Unknown Category")

           XCTAssertEqual(backgroundImageName, "myMatches", "The background image for an unknown category should default to 'myMatches'")
       }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {

            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
