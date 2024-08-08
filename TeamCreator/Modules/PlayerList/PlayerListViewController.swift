//
//  PlayerListViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit

protocol PlayerListViewControllerProtocol: AnyObject {
    func reloadTableView()
}

final class PlayerListViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PlayerListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlayerListViewModel()
        registerCells()
    
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchData()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "PlayerListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerListTableViewCell")
        tableView.register(UINib(nibName: "AddPlayerButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "AddPlayerButtonTableViewCell")
    }
}

extension PlayerListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getCellTypeCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = viewModel.getCellType(at: section)
        switch cellType {
        case .player:
            return 2
        case .addButton:
            return 1
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.getCellType(at: indexPath.section)
        switch cellType {
        case .player:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTableViewCell", for: indexPath) as? PlayerListTableViewCell else { return UITableViewCell() }
            return cell
        case .addButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayerButtonTableViewCell", for: indexPath) as? AddPlayerButtonTableViewCell else { return UITableViewCell()}
            return cell
        }
    }
    
    
}

extension PlayerListViewController: PlayerListViewControllerProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}
