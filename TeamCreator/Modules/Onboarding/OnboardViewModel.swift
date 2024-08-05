//
//  OnboardingViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 29.07.2024.
//
import Foundation

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

enum OnboardViewState {
    case updateSlides
    case navigateToEntry
    case noInternetConnection
}

final class OnboardViewModel: OnboardViewModelProtocol {
    
    var updateUI: ((OnboardViewState) -> Void)?
    
    var slides: [OnboardSlide] = [
        OnboardSlide(title: "Creating a team has never been easier.\n Get started today and create your own team!", description: "Welcome to TeamCreator!", imageName: "creative"),
        OnboardSlide(title: "Choose your favorite sport and create your teams.", description: "Now Select Date and Time Easily! Reservation Has Never Been This Fast and Smooth.", imageName: "add-friend"),
        OnboardSlide(title: "Create a match and select your players.", description: "Once you have created your team, easily organize and manage matches. Get started and enjoy the game!", imageName: "team"),
    ]
    
    private var currentPage: Int = 0 {
        didSet {
            updateUI?(.updateSlides)
        }
    }
    
    func viewDidLoad() {
        checkInternetConnection()
    }
    
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
}
