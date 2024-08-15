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
           // Given
           XCTAssertEqual(viewModel.getItemsCount(), 0, "Initial items count should be 0")

           // When
           viewModel.fetchItems()

           // Then
           XCTAssertEqual(viewModel.getItemsCount(), 3, "Items count should be 3 after fetching items")
           XCTAssertTrue(mockDelegate.didCallReloadCollectionView, "reloadCollectionView should be called after fetching items")
       }

       func testGetItemAtIndex() {
           // Given
           viewModel.fetchItems()

           // When
           let item = viewModel.getItem(at: 1)

           // Then
           XCTAssertEqual(item.category, "Create Match", "The item category at index 1 should be 'Create Match'")
       }

       func testGetBackgroundImageNameForCategoryFootball() {
           // Given
           SelectedSportManager.shared.selectedSport = .football

           // When
           let backgroundImageName = viewModel.getBackgroundImageName(for: "Players")

           // Then
           XCTAssertEqual(backgroundImageName, "footballPlayers", "The background image for 'Players' in football should be 'footballPlayers'")
       }

       func testGetBackgroundImageNameForCategoryBasketball() {
           // Given
           SelectedSportManager.shared.selectedSport = .basketball

           // When
           let backgroundImageName = viewModel.getBackgroundImageName(for: "Create Match")

           // Then
           XCTAssertEqual(backgroundImageName, "createBasketball", "The background image for 'Create Match' in basketball should be 'createBasketball'")
       }

       func testGetBackgroundImageNameForCategoryVolleyball() {
           // Given
           SelectedSportManager.shared.selectedSport = .volleyball

           // When
           let backgroundImageName = viewModel.getBackgroundImageName(for: "My Matches")

           // Then
           XCTAssertEqual(backgroundImageName, "myMatches", "The background image for 'My Matches' in volleyball should be 'myMatches'")
       }

       func testGetBackgroundImageNameForUnknownCategory() {
           // Given
           SelectedSportManager.shared.selectedSport = .volleyball

           // When
           let backgroundImageName = viewModel.getBackgroundImageName(for: "Unknown Category")

           // Then
           XCTAssertEqual(backgroundImageName, "myMatches", "The background image for an unknown category should default to 'myMatches'")
       }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
