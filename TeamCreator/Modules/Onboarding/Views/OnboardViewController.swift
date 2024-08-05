//
//  OnboardViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import UIKit

class OnboardViewController: BaseViewController {
    
    var viewModel: OnboardViewModelProtocol!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardViewModel()
        setupCollectionView()
        setupPageControl()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: OnboardViewCell.self)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.getNumberOfSlides()
    }
    
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] state in
            self?.updateUI(for: state)
        }
    }
    
    private func updateUI(for state: OnboardViewState) {
        switch state {
        case .updateSlides:
            collectionView.reloadData()
            pageControl.currentPage = viewModel.getCurrentPage()
        case .navigateToEntry:
            navigateToEntry()
        case .noInternetConnection:
            showAlert("Error", "No Internet connection, please check your connection")
        }
    }
    
    private func navigateToEntry() {
        guard let window = view.window else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let entryVC = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as? EntryViewController else { return }
        
        let navigationController = UINavigationController(rootViewController: entryVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        viewModel.nextPage()
        
        let nextIndexPath = IndexPath(item: viewModel.getCurrentPage(), section: 0)
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        
        if viewModel.isLastPage() {
            nextButton.setTitle("Get Started", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }
}

extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfSlides()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardViewCell", for: indexPath) as? OnboardViewCell else {
            return UICollectionViewCell()
        }
        
        let slide = viewModel.getSlide(at: indexPath.row)
        cell.setupCell(with: slide)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / collectionView.frame.width)
        viewModel.setCurrentPage(pageIndex)
    }
}
