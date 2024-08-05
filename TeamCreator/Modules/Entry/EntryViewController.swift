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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 35, height: UIScreen.main.bounds.height / 5)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        entryCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
        viewModel.navigateToSecond()
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
}

//MARK: EntryViewControllerProtocol

extension EntryViewController: EntryViewModelDelegate {
    func reloadCollectionView() {
        entryCollectionView.reloadData()
    }
    
    func navigateToSecond() {
        guard let window = view.window else { return }
        let storyboard = UIStoryboard(name: "SecondViewController", bundle: nil)
        guard let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }
        
        let secondViewModel = SecondViewModel(delegate: secondVC)
        secondVC.viewModel = secondViewModel
        
        window.rootViewController = secondVC
        window.makeKeyAndVisible()
    }
}

