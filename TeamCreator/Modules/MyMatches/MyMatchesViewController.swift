//
//  MyMatchesViewController.swift
//  TeamCreator
//
//  Created by Giray Aksu on 13.08.2024.
//

import UIKit

class MyMatchesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MyMatchesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        fetchData()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MyMatchesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyMatchesCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViewModel() {
        let repository = MatchRepository() // MatchRepository'den bir örnek oluşturuyoruz
        viewModel = MyMatchesViewModel(repository: repository)
    }
    
    private func fetchData() {
        guard let selectedSport = SelectedSportManager.shared.selectedSport else {
            print("No sport selected")
            return
        }
        
        viewModel.fetchMatches(for: selectedSport.rawValue) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching matches: \(error.localizedDescription)")
            }
        }
    }
}


extension MyMatchesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyMatchesCell", for: indexPath) as? MyMatchesTableViewCell else {
            return UITableViewCell()
        }
        
        let match = viewModel.match(at: indexPath.row)
        cell.configure(with: match)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let matchToDelete = viewModel.match(at: indexPath.row)
            viewModel.deleteMatch(matchToDelete) { [weak self] success in
                guard success else {
                    self?.showAlert("Error", "Failed to delete match.")
                    return
                }
                
                // Tablodaki hücreyi güncelle
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

extension MyMatchesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMatch = viewModel.match(at: indexPath.row)
        navigateToTeamViewController(with: selectedMatch)
    }

    private func navigateToTeamViewController(with match: Match) {
        navigateToViewController(storyboardName: "TeamView", viewControllerIdentifier: "TeamViewController") { (teamVC: TeamViewController) in
            let teamViewModel = TeamViewModel(teamA: match.teamA, teamB: match.teamB, location: match.location, matchDate: match.date)
            teamVC.viewModel = teamViewModel
        }
    }
}



