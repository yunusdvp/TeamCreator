//
//  EntryViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//
import UIKit

protocol EntryViewControllerProtocol: AnyObject {
    func reloadCollectionView()
    func navigateToSecond()
}

final class EntryViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var entryCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!

    //MARK: - Proporties
    var viewModel: EntryViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    //MARK: -Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EntryViewModel()
        prepareCollectionView()
        viewModel.fetchSports()
    }

    //MARK: Private Functions

    private func prepareCollectionView() {
        entryCollectionView.dataSource = self
        entryCollectionView.delegate = self
        entryCollectionView.register(cellType: EntryCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = LayoutConstants.itemSize
        layout.minimumLineSpacing = LayoutConstants.minimumLineSpacing
        layout.sectionInset = LayoutConstants.sectionInset
        entryCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//MARK: UICollectionViewDelegate and UICollectionViewDataSource Functions

extension EntryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSportsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(with: EntryCollectionViewCell.self, for: indexPath)
            else { return UICollectionViewCell() }
        let sport = viewModel.getSport(at: indexPath.row)
        cell.configure(with: sport)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { viewModel.selectSport(at: indexPath.row) }
}

//MARK: EntryViewControllerProtocol

extension EntryViewController: EntryViewModelDelegate {
    func reloadCollectionView() { 
        entryCollectionView.reloadData()
    }

    func navigateToSecond() {
        navigateToViewController(storyboardName: "SecondView", viewControllerIdentifier: "SecondViewController") { (secondVC: SecondViewController) in
            let secondViewModel = SecondViewModel(delegate: secondVC)
            secondVC.viewModel = secondViewModel
        }
    }
}

//MARK: Layout Constants
private extension EntryViewController{
    
}
≈
