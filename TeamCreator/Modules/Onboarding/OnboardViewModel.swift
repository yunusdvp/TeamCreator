//
//  OnboardingViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 29.07.2024.
//
import Foundation

protocol OnboardViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
    func navigateToEntry()
    func showNoInternetConnectionAlert()
}


// MARK: - OnboardViewModelProtocol
protocol OnboardViewModelProtocol: AnyObject {
    var delegate: OnboardViewModelDelegate? { get set }
    var numberOfSlides: Int { get }
    var currentPage: Int { get }
    var cellPadding: CGFloat { get }

    func load()
    func slide(at index: Int) -> OnboardSlide
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

    weak var delegate: OnboardViewModelDelegate?

    var slides: [OnboardSlide] = []

    private(set) var currentPage: Int = 0

    let cellPadding: CGFloat = 16.0

    // MARK: - Lifecycle Methods
    func load() {
        delegate?.showLoadingView()
        loadSlidesFromJSON()
        checkInternetConnection()
    }

    // MARK: - Public Methods
    var numberOfSlides: Int {
        return slides.count
    }

    func slide(at index: Int) -> OnboardSlide {
        return slides[index]
    }

    func nextPage() {
        if currentPage < slides.count - 1 {
            currentPage += 1
            delegate?.reloadData()
        } else {
            delegate?.navigateToEntry()
        }
    }

    func isLastPage() -> Bool {
        return currentPage == slides.count - 1
    }

    private func checkInternetConnection() {
        let internetStatus = API.shared.isConnectoInternet()
        delegate?.hideLoadingView()
        if internetStatus {
            delegate?.reloadData()
        } else {
            delegate?.showNoInternetConnectionAlert()
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
