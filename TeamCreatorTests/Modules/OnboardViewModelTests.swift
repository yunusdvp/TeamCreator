//
//  OnboardViewModelTests.swift
//  TeamCreatorTests
//
//  Created by Yunus Emre ÖZŞAHİN on 13.08.2024.
//

import XCTest
@testable import TeamCreator

final class OnboardViewModelTests: XCTestCase {
    
    var viewModel: OnboardViewModel!
    var mockDelegate: MockOnboardViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockOnboardViewModelDelegate()
        viewModel = OnboardViewModel()
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testLoad_ShouldFetchSlidesAndReloadData() {
        // Given
        XCTAssertFalse(mockDelegate.didCallReloadData)
        
        // When
        viewModel.load()
        
        // Then
        XCTAssertTrue(mockDelegate.didCallShowLoadingView)
        XCTAssertTrue(mockDelegate.didCallHideLoadingView)
        XCTAssertTrue(mockDelegate.didCallReloadData)
    }
    
    func testNextPage_ShouldUpdateCurrentPageAndReloadData() {
        // Given
        viewModel.load()
        XCTAssertEqual(viewModel.currentPage, 0)
        
        // When
        viewModel.nextPage()
        
        // Then
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(mockDelegate.didCallReloadData)
    }
    
    func testNextPage_ShouldNavigateToEntry_WhenLastPageReached() {
        // Given
        viewModel.load()
        
        while !viewModel.isLastPage() {
            viewModel.nextPage()
        }
        
        // When
        viewModel.nextPage()
        
        // Then
        XCTAssertTrue(mockDelegate.didCallNavigateToEntry)
    }
    
    
    func testIsLastPage_ShouldReturnTrueWhenOnLastPage() {
        // Given
        viewModel.load()
        while !viewModel.isLastPage() {
            viewModel.nextPage()
        }
        
        // When
        let isLastPage = viewModel.isLastPage()
        
        // Then
        XCTAssertTrue(isLastPage)
    }
    
    func testIsLastPage_ShouldReturnFalseWhenNotOnLastPage() {
        // Given
        viewModel.load()
        viewModel.nextPage()
        
        // When
        let isLastPage = viewModel.isLastPage()
        
        // Then
        XCTAssertFalse(isLastPage)
    }
    
    
    
    // Mock Delegate Class
    class MockOnboardViewModelDelegate: OnboardViewModelDelegate {
        var didCallShowLoadingView = false
        var didCallHideLoadingView = false
        var didCallReloadData = false
        var didCallNavigateToEntry = false
        var didCallShowNoInternetConnectionAlert = false
        
        func showLoadingView() {
            didCallShowLoadingView = true
        }
        
        func hideLoadingView() {
            didCallHideLoadingView = true
        }
        
        func reloadData() {
            didCallReloadData = true
        }
        
        func navigateToEntry() {
            didCallNavigateToEntry = true
        }
        
        func showNoInternetConnectionAlert() {
            didCallShowNoInternetConnectionAlert = true
        }
        
    }
}
