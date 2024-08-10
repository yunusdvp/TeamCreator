//
//  OnboardViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import UIKit

final class OnboardViewController: BaseViewController {

    var viewModel: OnboardViewModelProtocol!
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardViewModel()
        setupCollectionView()
        setupPageControl()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private Methods
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

        let storyboard = UIStoryboard(name: "EntryViewController", bundle: nil)
        guard let entryVC = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as? EntryViewController else { return }

        let navigationController = UINavigationController(rootViewController: entryVC)
        window.setRootViewController(navigationController)
        window.makeKeyAndVisible()
    }

    // MARK: - Actions
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.getNumberOfSlides()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(with: OnboardViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }

        let slide = viewModel.getSlide(at: indexPath.row)
        cell.setupCell(with: slide)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / collectionView.frame.width)
        viewModel.setCurrentPage(pageIndex)
    }
}
