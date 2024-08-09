//
//  PlayerListViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import UIKit

protocol PlayerListViewControllerProtocol: AnyObject {
    func reloadTableView()
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
                        print("Oyuncular başarıyla getirildi: \(players)")
                        // Oyuncuları UI'da göstermek için burada işlemler yapabilirsiniz.
                    case .failure(let error):
                        print("Oyuncular getirilirken hata oluştu: \(error.localizedDescription)")
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
    
    
}

extension PlayerListViewController: PlayerListViewControllerProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func navigateToPlayerCRUD() {
        navigateToViewController(storyboardName: "PlayerCRUDViewController", viewControllerIdentifier: "PlayerCRUDViewController") { (playerCRUDVC: PlayerCRUDViewController) in
            let playerCRUDViewModel = PlayerCRUDViewModel()
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
