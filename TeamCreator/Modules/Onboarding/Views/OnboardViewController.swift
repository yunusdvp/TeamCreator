//
//  OnboardViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import UIKit

final class OnboardViewController: BaseViewController {
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!

    var viewModel: OnboardViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }

    // MARK: - Private Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: OnboardViewCell.self)
    }

    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.numberOfSlides
    }
    private func updateNextButtonTitle() {
        if viewModel.isLastPage() {
            nextButton.setTitle("Get Started", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }


    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        viewModel.nextPage()
        updateNextButtonTitle()

        let nextIndexPath = IndexPath(item: viewModel.currentPage, section: 0)
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.numberOfSlides
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(with: OnboardViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }

        let slide = viewModel.slide(at: indexPath.row)
        cell.setupCell(with: slide)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.size.width - (viewModel.cellPadding * 2),
            height: collectionView.frame.size.height
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: viewModel.cellPadding,
            bottom: 0,
            right: viewModel.cellPadding
        )
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / collectionView.frame.width)
        viewModel.currentPage
    }
}


extension OnboardViewController: OnboardViewModelDelegate {

    func showLoadingView() {
        showLoading()
    }

    func hideLoadingView() {
        hideLoading()
    }

    func reloadData() {
        collectionView.reloadData()
        pageControl.currentPage = viewModel.currentPage
    } 

    func navigateToEntry() {
        guard let window = view.window else { return }

        let storyboard = UIStoryboard(name: "EntryViewController", bundle: nil)
        guard let entryVC = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as? EntryViewController else { return }

        let navigationController = UINavigationController(rootViewController: entryVC)
        window.setRootViewController(navigationController)
        window.makeKeyAndVisible()
    }

    func showNoInternetConnectionAlert() {
        showAlert("Error", "No Internet connection, please check your connection")
    }
}
