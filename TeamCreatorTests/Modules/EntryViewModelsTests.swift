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
           XCTAssertEqual(viewModel.getSportsCount(), 0, "Initial sports count should be 0")

           viewModel.fetchSports()

           XCTAssertEqual(viewModel.getSportsCount(), 3, "Sports count should be 3 after fetching sports")
           XCTAssertTrue(mockDelegate.didCallReloadCollectionView, "reloadCollectionView should be called after fetching sports")
       }

       func testGetSportAtIndex() {
           viewModel.fetchSports()

           let sport = viewModel.getSport(at: 1)

           XCTAssertEqual(sport.name, "Volleyball", "The sport name at index 1 should be Volleyball")
           XCTAssertEqual(sport.type, .volleyball, "The sport type at index 1 should be Volleyball")
       }

       func testSelectSportAtIndex() {
           viewModel.fetchSports()

           viewModel.selectSport(at: 0)

           XCTAssertEqual(SelectedSportManager.shared.selectedSport, .football, "The selected sport should be Football")
           XCTAssertTrue(mockDelegate.didCallNavigateToSecond, "navigateToSecond should be called after selecting a sport")
       }

       func testLoad() {

           XCTAssertEqual(viewModel.getSportsCount(), 0, "Initial sports count should be 0")

           viewModel.load()

           XCTAssertEqual(viewModel.getSportsCount(), 3, "Sports count should be 3 after loading sports")
           XCTAssertTrue(mockDelegate.didCallReloadCollectionView, "reloadCollectionView should be called after loading sports")
       }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {

            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
