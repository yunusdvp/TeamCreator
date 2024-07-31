//
//  OnboardingViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 29.07.2024.
//
import Foundation
import UIKit

protocol OnboardViewModelProtocol: AnyObject {
    func getNumberOfSlides() -> Int
    func getSlide(at index: Int) -> OnboardSlide
    func getCurrentPage() -> Int
    func setCurrentPage(_ index: Int)
    func nextPage()
    func isLastPage() -> Bool
    var updateUI: (() -> Void)? { get set }
}

final class OnboardViewModel: OnboardViewModelProtocol {
    
    weak var view: OnboardViewControllerProtocol?
    var coordinator: OnboardCoordinatorProtocol?
    
    init(view: OnboardViewControllerProtocol, coordinator: OnboardCoordinatorProtocol) {
        self.view = view
        self.coordinator = coordinator
        
    }
    
    var slides: [OnboardSlide] = [
        OnboardSlide(title: "Creating a team has never been easier.\n Get started today and create your own team! ", description: "Welcome to TeamCreator!", image: UIImage(named: "creative")!),
        OnboardSlide(title: "Choose your favorite sport and create your teams.", description: "Now Select Date and Time Easily! Reservation Has Never Been This Fast and Smooth.", image: UIImage(named: "add-friend")!),
        OnboardSlide(title: "Create a match and select your players.", description: "Once you have created your team, easily organize and manage matches. Get started and enjoy the game!", image: UIImage(named: "team")!),
    ]
    
    private var currentPage: Int = 0 {
        didSet {
            updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    
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
        }
    }
    
    func isLastPage() -> Bool {
        return currentPage == slides.count - 1
    }
    
}

