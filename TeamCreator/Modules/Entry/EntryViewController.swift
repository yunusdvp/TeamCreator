//
//  EntryViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//
import UIKit

class EntryViewController: BaseViewController {
    
    var viewModel: EntryViewModelInterface!
    
    @IBOutlet weak var entryCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EntryViewModel(view: self)
        prepareCollectionView()
        viewModel.fetchSports()
    }
    
    //MARK: Private Functions

    private func prepareCollectionView() {
        entryCollectionView.dataSource = self
        entryCollectionView.delegate = self
        entryCollectionView.register(cellType: EntryCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-35, height: UIScreen.main.bounds.height/5)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        entryCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//MARK: UICollectionViewDelegate and UICollectionViewDataSource Functions

extension EntryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sports.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: EntryCollectionViewCell.self, for: indexPath)
        cell.configure(with: viewModel.sports[indexPath.row])
        return cell
    }
}

//MARK: EntryViewInterface

extension EntryViewController: EntryViewInterface {
    func reloadCollectionView() {
        entryCollectionView.reloadData()
    }
}
