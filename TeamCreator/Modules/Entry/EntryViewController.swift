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

class EntryViewController: BaseViewController {

    var viewModel: EntryViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    @IBOutlet weak var entryCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!

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
        entryCollectionView.register(UINib(nibName: "EntryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EntryCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 35, height: UIScreen.main.bounds.height / 5.25)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        entryCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

//MARK: UICollectionViewDelegate and UICollectionViewDataSource Functions

extension EntryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSportsCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EntryCollectionViewCell", for: indexPath) as? EntryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let sport = viewModel.getSport(at: indexPath.row)
        cell.configure(with: sport)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectSport(at: indexPath.row)
    }
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

