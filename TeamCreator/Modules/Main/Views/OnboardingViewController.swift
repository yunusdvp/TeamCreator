//
//  OnboardingViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 29.07.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides = [OnboardingSlide]()
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        slides = [
            OnboardingSlide(title: "Welcome", description: "Do you want to buy a bus ticket? You are in the right place! Now you can buy it easily.", image: UIImage(named: "bus")!),
            OnboardingSlide(title: "Easy Reservation", description: "Now Select Date and Time Easily! Reservation Has Never Been This Fast and Smooth.", image: UIImage(named: "timetable")!),
            OnboardingSlide(title: "Different Payment Convenience", description: "Easy payment options", image: UIImage(named: "atm-card")!),
            OnboardingSlide(title: "24/7 Customer Service", description: "Our customer service team is with you 24/7 for all your transactions through.", image: UIImage(named: "")!)
        ]
          pageControl.numberOfPages = slides.count
    }
    func registerCell() {
        collectionView.register(OnboardingViewCell.self, forCellWithReuseIdentifier: String(describing: OnboardingViewCell.self))
    }
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(identifier: "LoginVC") as? UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }

}
extension OnboardingViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OnboardViewCell.self), for: indexPath) as? OnboardViewCell else {return UICollectionViewCell()}
            return cell
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let width = scrollView.frame.width
            currentPage = Int(scrollView.contentOffset.x / width)
    }
}
