//
//  SecondViewController.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import UIKit

protocol SecondViewControllerProtocol: AnyObject {
    func reloadCollectionView()
    func navigateToMatchCreate()
    func navigateToPlayerList()
}

class SecondViewController: BaseViewController {
    
    var viewModel: SecondViewModelProtocol!
    
    @IBOutlet weak var secondCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SecondViewModel(delegate: self)
        prepareCollectionView()
        viewModel.fetchMatches()
    }
    
    //MARK: Private Functions

    private func prepareCollectionView() {
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.register(UINib(nibName: "SecondCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SecondCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 35, height: UIScreen.main.bounds.height / 5)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        secondCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//MARK: UICollectionViewDelegate and UICollectionViewDataSource Functions

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMatchesCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: SecondCollectionViewCell.self, for: indexPath)
        let match = viewModel.getMatch(at: indexPath.item)
        cell?.configure(with: match)
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            viewModel.selectMatch(at: indexPath.row)
        }
}

//MARK: SecondViewControllerProtocol

extension SecondViewController: SecondViewModelDelegate {
    func reloadCollectionView() {
        secondCollectionView.reloadData()
    }
    
    func navigateToMatchCreate() {
        let storyboard = UIStoryboard(name: "MatchCreateViewController", bundle: nil)
        guard let matchCreateVC = storyboard.instantiateViewController(withIdentifier: "MatchCreateViewController") as? MatchCreateViewController else { return }
        
        let matchCreateViewModel = MatchCreateViewModel()
        matchCreateVC.viewModel = matchCreateViewModel
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(matchCreateVC, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: self)
            view.window?.rootViewController = navigationController
            view.window?.makeKeyAndVisible()
            DispatchQueue.main.async {
                navigationController.pushViewController(matchCreateVC, animated: true)
            }
        }
        
    }
    func navigateToPlayerList() {
        let storyboard = UIStoryboard(name: "PlayerListViewController", bundle: nil)
        guard let playerListVC = storyboard.instantiateViewController(withIdentifier: "PlayerListViewController") as? PlayerListViewController else { return }
        
        let playerListViewModel = PlayerListViewModel()
        playerListVC.viewModel = playerListViewModel
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(playerListVC, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: self)
            view.window?.rootViewController = navigationController
            view.window?.makeKeyAndVisible()
            DispatchQueue.main.async {
                navigationController.pushViewController(playerListVC, animated: true)
            }
        }
    }
}
