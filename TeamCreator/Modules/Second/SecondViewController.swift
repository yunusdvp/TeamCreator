//
//  SecondViewController.swift
//  TeamCreator
//
//  Created by Giray Aksu on 31.07.2024.
//

import UIKit

class SecondViewController: BaseViewController {
    
    var viewModel: SecondViewModelInterface!
    
    @IBOutlet weak var secondCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SecondViewModel(view: self)
        prepareCollectionView()
        viewModel.fetchMatches()
    }
    
    //MARK: Private Functions

    private func prepareCollectionView() {
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.register(cellType: SecondCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-35, height: UIScreen.main.bounds.height/5)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        secondCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//MARK: UICollectionViewDelegate and UICollectionViewDataSource Functions

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.matches.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: SecondCollectionViewCell.self, for: indexPath)
        cell.configure(with: viewModel.matches[indexPath.row])
        return cell
    }
}

//MARK: EntryViewInterface

extension SecondViewController: SecondViewInterface {
    func reloadCollectionView() {
        secondCollectionView.reloadData()
    }
}
