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
        XCTAssertFalse(mockDelegate.didCallReloadData)

        viewModel.load()
        
        XCTAssertTrue(mockDelegate.didCallShowLoadingView)
        XCTAssertTrue(mockDelegate.didCallHideLoadingView)
        XCTAssertTrue(mockDelegate.didCallReloadData)
    }
    
    func testNextPage_ShouldUpdateCurrentPageAndReloadData() {
        viewModel.load()
        XCTAssertEqual(viewModel.currentPage, 0)
        
        viewModel.nextPage()
        
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(mockDelegate.didCallReloadData)
    }
    
    func testNextPage_ShouldNavigateToEntry_WhenLastPageReached() {
        viewModel.load()
        
        while !viewModel.isLastPage() {
            viewModel.nextPage()
        }
        
        viewModel.nextPage()
        
        XCTAssertTrue(mockDelegate.didCallNavigateToEntry)
    }
    
    
    func testIsLastPage_ShouldReturnTrueWhenOnLastPage() {
        viewModel.load()
        while !viewModel.isLastPage() {
            viewModel.nextPage()
        }
        
        let isLastPage = viewModel.isLastPage()
        
        XCTAssertTrue(isLastPage)
    }
    
    func testIsLastPage_ShouldReturnFalseWhenNotOnLastPage() {
        viewModel.load()
        viewModel.nextPage()
        
        let isLastPage = viewModel.isLastPage()
        
        XCTAssertFalse(isLastPage)
    }
    
    
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
