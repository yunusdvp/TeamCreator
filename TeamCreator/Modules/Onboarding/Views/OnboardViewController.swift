//
//  OnboardViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import UIKit
protocol OnboardViewControllerProtocol: AnyObject {
    func updateUI()
}

 final class OnboardViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
     
    var viewModel: OnboardViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCell()
        pageControl.numberOfPages = viewModel.getNumberOfSlides()
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        viewModel.updateUI = { [weak self] in
            self?.updateUI()
        }
        updateUI()
    }
     @objc private func pageControlTapped(_ sender: UIPageControl) {
             let indexPath = IndexPath(item: sender.currentPage, section: 0)
             viewModel.setCurrentPage(sender.currentPage)
             collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
         }
    private func registerCell() {
        collectionView.register(UINib(nibName: String(describing: OnboardViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: OnboardViewCell.self))
    }
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if viewModel.isLastPage() {
            navigateToEntry()
          } else {
              viewModel.nextPage()
              collectionView.reloadData()
              let indexPath = IndexPath(item: viewModel.getCurrentPage(), section: 0)
              collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
          }
    }
     func navigateToEntry() {
         (viewModel as? OnboardViewModel)?.coordinator?.navigateToEntry()
     }
}

extension OnboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfSlides()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OnboardViewCell.self), for: indexPath) as? OnboardViewCell else {return UICollectionViewCell()}
                cell.setupCell(viewModel.getSlide(at: indexPath.row))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / width)
        viewModel.setCurrentPage(currentPage)
    }
}

extension OnboardViewController: OnboardViewControllerProtocol {
     func updateUI() {
        pageControl.currentPage = viewModel.getCurrentPage()
        let buttonTitle = viewModel.isLastPage() ? "Get Started" : "Next"
        nextButton.setTitle(buttonTitle, for: .normal)
    }
}
