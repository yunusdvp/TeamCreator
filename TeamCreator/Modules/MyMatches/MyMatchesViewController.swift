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
    private var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        setupEmptyView()
        fetchDataAndReloadTable()
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

    private func setupEmptyView() {
        emptyView = EmptyView(frame: tableView.bounds)
        emptyView.isHidden = true
        view.addSubview(emptyView)
    }
    
    func fetchDataAndReloadTable() {
        guard let selectedSport = SelectedSportManager.shared.selectedSport else {
            print("No sport selected")
            return
        }

        showLoading()
        viewModel.fetchMatches(for: selectedSport.rawValue) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading()
                switch result {
                case .success:
                    self?.updateUI()
                case .failure(let error):
                    print("Error fetching matches: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateUI() {
        if viewModel.numberOfRows() == 0 {
            tableView.isHidden = true
            emptyView.isHidden = false
        } else {
            tableView.isHidden = false
            emptyView.isHidden = true
            tableView.reloadData()
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
            viewModel.removeMatch(matchToDelete) { [weak self] success in
                guard success else {
                    self?.showAlert("Error", "Failed to delete match.")
                    return
                }
                
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.updateUI()
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



