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
    func showLoading()
    func hideLoading()
}

protocol PlayerListViewControllerDelegate: AnyObject {
    func didUpdatePlayerList()
}


final class PlayerListViewController: BaseViewController{
    
    
    @IBOutlet private weak var filterIcon: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var isAscendingOrder: Bool = true
    
    var viewModel: PlayerListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        showLoading()
        tableView.delegate = self
        tableView.dataSource = self
        
        let selectedSport = SelectedSportManager.shared.selectedSport?.rawValue ?? ""
        
        viewModel.fetchPlayers(sporType: selectedSport) { [weak self] result in
            self?.hideLoading()
            
            switch result {
            case .success(let players):
                print("Players successfully fetched: \(players)")
            case .failure(let error):
                print("Error fetching players: \(error.localizedDescription)")
            }
        }
    }
    
    private func registerCells() {
        tableView.register(cellType: PlayerListTableViewCell.self)
        tableView.register(cellType: AddPlayerButtonTableViewCell.self)
    }
    
    @IBAction func filterIconButtonClicked(_ sender: UIBarButtonItem) {
        viewModel.toggleSortOrder()
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
            let cell = tableView.dequeCell(cellType: PlayerListTableViewCell.self, indexPath: indexPath)
            if let player = viewModel.getPlayer(at: indexPath.row) {
                cell.configure(with: player)
            }
            return cell
        case .addButton:
            let cell = tableView.dequeCell(cellType: AddPlayerButtonTableViewCell.self, indexPath:indexPath)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 15 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView()
            headerView.backgroundColor = .clear
            return headerView
        } else {
            return nil
        }
    }
}

extension PlayerListViewController: PlayerListViewControllerProtocol {
    func navigateToPlayerCRUD() {
        navigateToViewController(
            storyboardName: "PlayerCRUDViewController",
            viewControllerIdentifier: "PlayerCRUDViewController",
            configure: { (playerCRUDVC: PlayerCRUDViewController) in
                let playerCRUDViewModel = PlayerCRUDViewModel()
                playerCRUDVC.viewModel = playerCRUDViewModel
                playerCRUDVC.delegate = self
            },
            backTo: { (backVC: UIViewController) in
                if let homeVC = backVC as? DashboardViewController {
                    let homeViewModel = DashboardViewModel()
                    homeVC.viewModel = homeViewModel
                }
            }
        )
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func navigateToPlayerCRUD(with player: Player) {
        navigateToViewController(
            storyboardName: "PlayerCRUDViewController",
            viewControllerIdentifier: "PlayerCRUDViewController",
            configure: { (playerCRUDVC: PlayerCRUDViewController) in
                let playerCRUDViewModel = PlayerCRUDViewModel(player: player)
                playerCRUDVC.viewModel = playerCRUDViewModel
                playerCRUDVC.delegate = self
            },
            backTo: { (backVC: UIViewController) in
                if let homeVC = backVC as? DashboardViewController {
                    let homeViewModel = DashboardViewModel()
                    homeVC.viewModel = homeViewModel
                }
            }
        )
    }
    
}

extension PlayerListViewController: AddPlayerButtonTableViewCellDelegate {
    func didTapButton() {
        print("Buton tıklandı")
        navigateToPlayerCRUD()
    }
}

extension PlayerListViewController: PlayerListViewControllerDelegate {
    func didUpdatePlayerList() {
        print("delegate çağırıldı")
        viewModel.fetchPlayers(sporType: SelectedSportManager.shared.selectedSport?.rawValue ?? "") { [weak self] result in
            switch result {
            case .success:
                print("yeni veriler çekildi")
                self?.reloadTableView()
            case .failure(let error):
                print("Error updating player list: \(error.localizedDescription)")
            }
        }
    }
}
