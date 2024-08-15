//
//  DashboardViewController.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import UIKit

protocol DashboardViewControllerProtocol: AnyObject {
    func reloadCollectionView()
    func navigateToMatchCreate()
    func navigateToPlayerList()
}

final class DashboardViewController: BaseViewController {
    
    // MARK: - Properties
    var viewModel: DashboardViewModelProtocol!

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    
    // MARK: - Initializer
    init(viewModel: DashboardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        prepareCollectionView()
        viewModel.fetchItems()
    }
    
    // MARK: Private Functions
    private func prepareCollectionView() {
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.register(cellType: DashboardCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = LayoutConstants.itemSize
        layout.minimumLineSpacing = LayoutConstants.minimumLineSpacing
        layout.sectionInset = LayoutConstants.sectionInset
        secondCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//MARK: UICollectionViewDelegate and UICollectionViewDataSource Functions
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getItemsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(with: DashboardCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
        var item = viewModel.getItem(at: indexPath.item)
        item.backgroundImage = viewModel.getBackgroundImageName(for: item.category ?? "default")
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            navigateToPlayerList()
        case 1:
            navigateToMatchCreate()
        case 2:
            navigateToMyMatches()
        default:
            break
        }
    }
}

// MARK: DashboardViewControllerProtocol
extension DashboardViewController: DashboardViewModelDelegate {
    func reloadCollectionView() {
        secondCollectionView.reloadData()
    }

    func navigateToMatchCreate() {
        navigateToViewController(storyboardName: "MatchCreateViewController", viewControllerIdentifier: "MatchCreateViewController") { (matchCreateVc: MatchCreateViewController) in
            let matchCreateViewModel = MatchCreateViewModel()
            matchCreateVc.viewModel = matchCreateViewModel
        }
    }

    func navigateToPlayerList() {
        navigateToViewController(storyboardName: "PlayerListViewController", viewControllerIdentifier: "PlayerListViewController") { (playerListVC: PlayerListViewController) in
            let playerListViewModel = PlayerListViewModel()
            playerListVC.viewModel = playerListViewModel
        }
    }

    func navigateToMyMatches() {
        navigateToViewController(storyboardName: "MyMatchesView", viewControllerIdentifier: "MyMatchesViewController") { (myMatchesVC: MyMatchesViewController) in
        }
    }
}

//MARK: Layout Constants
private extension DashboardViewController {
    enum LayoutConstants {
        static let itemSize = CGSize(width: UIScreen.main.bounds.width - 35, height: UIScreen.main.bounds.height / 5.25)
        static let minimumLineSpacing: CGFloat = 20
        static let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
