//
//  PlayerListViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit

protocol PlayerListViewControllerProtocol: AnyObject {
    func reloadTableView()
    func navigateToPlayerCRUD(with player: Player)
    func navigateToPlayerCRUD()
}

final class PlayerListViewController: BaseViewController {
    
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
        
        let selectedSport = SelectedSportManager.shared.selectedSport?.rawValue ?? ""
        viewModel.fetchPlayers(sporType: selectedSport) { result in
            switch result {
            case .success(let players):
                print("Players successfully fetched: \(players)")
            case .failure(let error):
                print("Error fetching players: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func registerCells() {
        tableView.register(UINib(nibName: "PlayerListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerListTableViewCell")
        tableView.register(UINib(nibName: "AddPlayerButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "AddPlayerButtonTableViewCell")
    }
    
    
}

extension PlayerListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {viewModel.getCellTypeCount()}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = viewModel.getCellType(at: section)
        switch cellType {
        case .player:
            return viewModel.getPlayerCount()
        case .addButton:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.getCellType(at: indexPath.section)
        switch cellType {
        case .player:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTableViewCell", for: indexPath) as? PlayerListTableViewCell else { return UITableViewCell() }
            if let player = viewModel.getPlayer(at: indexPath.row) {
                cell.configure(with: player)
            }
            return cell
        case .addButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayerButtonTableViewCell", for: indexPath) as? AddPlayerButtonTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let player = viewModel.getPlayer(at: indexPath.row),
                  let playerId = player.id else { return }
            
            let alertController = UIAlertController(title: "Delete Player", message: "Are you sure you want to delete this player?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.viewModel.removePlayer(playerId: playerId) { result in
                    switch result {
                    case .success:
                        print("Player successfully deleted")
                        
                        self?.tableView.performBatchUpdates({
                            self?.tableView.deleteRows(at: [indexPath], with: .fade)
                        }, completion: nil)
                        
                    case .failure(let error):
                        print("Error deleting player: \(error.localizedDescription)")
                    }
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cellType = viewModel.getCellType(at: indexPath.section)
            if cellType == .player, let player = viewModel.getPlayer(at: indexPath.row) {
                navigateToPlayerCRUD(with: player)
            }
        }
}

extension PlayerListViewController: PlayerListViewControllerProtocol {
    func navigateToPlayerCRUD() {
        navigateToViewController(storyboardName: "PlayerCRUDViewController", viewControllerIdentifier: "PlayerCRUDViewController") { (playerCRUDVC: PlayerCRUDViewController) in
            let playerCRUDViewModel = PlayerCRUDViewModel()
            playerCRUDVC.viewModel = playerCRUDViewModel
        }
    }

    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func navigateToPlayerCRUD(with player: Player) {
            navigateToViewController(storyboardName: "PlayerCRUDViewController", viewControllerIdentifier: "PlayerCRUDViewController") { (playerCRUDVC: PlayerCRUDViewController) in
                let playerCRUDViewModel = PlayerCRUDViewModel()
                playerCRUDViewModel.player = player
                playerCRUDVC.viewModel = playerCRUDViewModel
            }
        }
}
extension PlayerListViewController: AddPlayerButtonTableViewCellDelegate {
    func didTapButton() {
        print("Buton tıklandı")
        navigateToPlayerCRUD()
    }
}
