//
//  PlayerListViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit

final class PlayerListViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var viewModel = PlayerListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func registerCells(){
        tableView.register(cellType: PlayerListTableViewCell.self)
        tableView.register(cellType: AddPlayerButtonTableViewCell.self)
    }
    
}

extension PlayerListViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.celltypeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let celltypeList = viewModel.celltypeList
        switch celltypeList[section] {
        case .player:
            return 2
        case .addButton:
            return 1
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.celltypeList[indexPath.section] {
        case .player:
            let cell = tableView.dequeCell(cellType: PlayerListTableViewCell.self, indexPath: indexPath)
            return cell
        case .addButton:
            let cell = tableView.dequeCell(cellType: AddPlayerButtonTableViewCell.self, indexPath: indexPath)
            return cell
        }
    }
}

