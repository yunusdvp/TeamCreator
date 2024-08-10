//
//  OnboardingViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 29.07.2024.
//
import Foundation

// MARK: - OnboardViewModelProtocol
protocol OnboardViewModelProtocol: AnyObject {
    var updateUI: ((OnboardViewState) -> Void)? { get set }
    
    func viewDidLoad()
    func getNumberOfSlides() -> Int
    func getSlide(at index: Int) -> OnboardSlide
    func getCurrentPage() -> Int
    func setCurrentPage(_ index: Int)
    func nextPage()
    func isLastPage() -> Bool
}

// MARK: - OnboardViewState Enum
enum OnboardViewState {
    case updateSlides
    case navigateToEntry
    case noInternetConnection
}

final class OnboardViewModel: OnboardViewModelProtocol {
    
    var updateUI: ((OnboardViewState) -> Void)?
    
    var slides: [OnboardSlide] = []
    
    private var currentPage: Int = 0 {
        didSet {
            updateUI?(.updateSlides)
        }
    }
    // MARK: - Lifecycle Methods
    func viewDidLoad() {
        loadSlidesFromJSON()
        checkInternetConnection()
    }

    // MARK: - Public Methods
    func getNumberOfSlides() -> Int {
        return slides.count
    }
    
    func getSlide(at index: Int) -> OnboardSlide {
        return slides[index]
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func setCurrentPage(_ index: Int) {
        currentPage = index
    }
    
    func nextPage() {
        if currentPage < slides.count - 1 {
            currentPage += 1
        } else {
            updateUI?(.navigateToEntry)
        }
    }
    
    func isLastPage() -> Bool {
        return currentPage == slides.count - 1
    }
    
    // MARK: - Private Methods
    private func checkInternetConnection() {
        let internetStatus = API.shared.isConnectoInternet()
        if internetStatus {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.updateUI?(.updateSlides)
            }
        } else {
            updateUI?(.noInternetConnection)
        }
    }
    private func loadSlidesFromJSON() {
        guard let url = Bundle.main.url(forResource: "onboard_data", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let onboardData = try JSONDecoder().decode(OnboardData.self, from: data)
            self.slides = onboardData.screens
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }

}
