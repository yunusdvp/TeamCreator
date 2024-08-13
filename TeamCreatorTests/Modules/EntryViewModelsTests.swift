//
//  EntryViewModelsTests.swift
//  TeamCreatorTests
//
//  Created by Yunus Emre ÖZŞAHİN on 13.08.2024.
//

import XCTest
@testable import TeamCreator

class MockEntryViewModelDelegate: EntryViewModelDelegate {
    var didCallReloadCollectionView = false
    var didCallNavigateToSecond = false

    func reloadCollectionView() {
        didCallReloadCollectionView = true
    }

    func navigateToSecond() {
        didCallNavigateToSecond = true
    }
}


final class EntryViewModelsTests: XCTestCase {

    var viewModel: EntryViewModel!
       var mockDelegate: MockEntryViewModelDelegate!

       override func setUp() {
           super.setUp()
           mockDelegate = MockEntryViewModelDelegate()
           viewModel = EntryViewModel()
           viewModel.delegate = mockDelegate
       }

       override func tearDown() {
           viewModel = nil
           mockDelegate = nil
           super.tearDown()
       }

       func testFetchSports() {
           // Given
           XCTAssertEqual(viewModel.getSportsCount(), 0, "Initial sports count should be 0")

           // When
           viewModel.fetchSports()

           // Then
           XCTAssertEqual(viewModel.getSportsCount(), 3, "Sports count should be 3 after fetching sports")
           XCTAssertTrue(mockDelegate.didCallReloadCollectionView, "reloadCollectionView should be called after fetching sports")
       }

       func testGetSportAtIndex() {
           // Given
           viewModel.fetchSports()

           // When
           let sport = viewModel.getSport(at: 1)

           // Then
           XCTAssertEqual(sport.name, "Volleyball", "The sport name at index 1 should be Volleyball")
           XCTAssertEqual(sport.type, .volleyball, "The sport type at index 1 should be Volleyball")
       }

       func testSelectSportAtIndex() {
           // Given
           viewModel.fetchSports()

           // When
           viewModel.selectSport(at: 0)

           // Then
           XCTAssertEqual(SelectedSportManager.shared.selectedSport, .football, "The selected sport should be Football")
           XCTAssertTrue(mockDelegate.didCallNavigateToSecond, "navigateToSecond should be called after selecting a sport")
       }

       func testLoad() {
           // Given
           XCTAssertEqual(viewModel.getSportsCount(), 0, "Initial sports count should be 0")

           // When
           viewModel.load()

           // Then
           XCTAssertEqual(viewModel.getSportsCount(), 3, "Sports count should be 3 after loading sports")
           XCTAssertTrue(mockDelegate.didCallReloadCollectionView, "reloadCollectionView should be called after loading sports")
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
