//
//  MatchCreateViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 5.08.2024.
//

import UIKit

protocol MatchCreateViewControllerProtocol: AnyObject {
    func reloadTableView()
}

class MatchCreateViewController: BaseViewController {

    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var locationTextField: UITextField!
    @IBOutlet private weak var playerTableView: UITableView!

    @IBOutlet weak var matchCreateButton: UIButton!
    var viewModel: MatchCreateViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    private var selectedPlayers: [Player] = []

    private var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        preparePickerView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }

    private func prepareTableView() {
        playerTableView.delegate = self
        playerTableView.dataSource = self
        playerTableView.register(cellType: PlayerListTableViewCell.self)
        playerTableView.allowsMultipleSelection = true
    }
    private func updateMatchCreateButtonTitle() {
        let count = selectedPlayers.count
        matchCreateButton.setTitle("Create Match (\(count) players)", for: .normal)
    }


    private func preparePickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self

        locationTextField.inputView = pickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        locationTextField.inputAccessoryView = toolbar
    }

    @objc private func donePicker() {
        locationTextField.resignFirstResponder()
    }

    @IBAction func matchCreateButtonTapped(_ sender: UIButton) {
        guard !selectedPlayers.isEmpty else {
            showAlert("Alert", "Please select at least one player.")
            return
        }
        guard let location = locationTextField.text, !location.isEmpty else {
            showAlert("Alert", "Please select a location.")
            return
        }
        let matchDate = datePicker.date
        guard matchDate > Date() else {
            showAlert("Alert", "Please select a valid match date.")
            return
        }
        guard let sportName = SelectedSportManager.shared.selectedSport?.rawValue else {
            showAlert("Alert", "Sport selection is missing.")
            return
        }
        viewModel.setSportCriteria(for: sportName)
        if let teams = viewModel.createBalancedTeams(from: selectedPlayers, sportName: sportName) {
            
            let teamA = teams.teamA
            let teamB = teams.teamB
            print(selectedPlayers)
            let teamAScore = viewModel.calculateTeamScore(for: teamA, sportName: sportName)
            let teamBScore = viewModel.calculateTeamScore(for: teamB, sportName: sportName)
            
            let location = locationTextField.text
            let matchDate = datePicker.date
            print(selectedPlayers)
            navigateToTeam(teamA: teamA, teamB: teamB, location: location, matchDate: matchDate)
            
        } else {
            print("Not enough players or invalid sport name."   )
        }
    }
}

extension MatchCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getPlayersCount(for: section) }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTableViewCell", for: indexPath) as? PlayerListTableViewCell else {
            return UITableViewCell()
        }
        let player = viewModel.getPlayer(at: indexPath)
        cell.configure(with: player)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = viewModel.getSectionTitle(for: indexPath.section)
        let player = viewModel.getPlayer(at: indexPath)
        selectedPlayers.append(player)
        updateMatchCreateButtonTitle()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let player = viewModel.getPlayer(at: indexPath)
        if let index = selectedPlayers.firstIndex(where: { $0.id == player.id }) {
            selectedPlayers.remove(at: index)
            updateMatchCreateButtonTitle()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.getSectionTitle(for: section)
    }
}

extension MatchCreateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getLocationsCount()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getLocationName(at: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        locationTextField.text = viewModel.getLocationName(at: row)
    }
}


extension MatchCreateViewController: MatchCreateViewModelDelegate {
    
    func navigateToTeam(teamA: Team?, teamB: Team?, location: String?, matchDate: Date?) {
        navigateToViewController(storyboardName: "TeamView", viewControllerIdentifier: "TeamViewController",
            configure: { (teamVC: TeamViewController) in

                let teamViewModel = TeamViewModel(teamA: teamA, teamB: teamB, location: location, matchDate: matchDate)
                teamVC.viewModel = teamViewModel
            },
            backTo: { (backVC: UIViewController) in
                if let dashVC = backVC as? DashboardViewController {
                    let dashViewModel = DashboardViewModel()
                    dashVC.viewModel = dashViewModel
                }
            }
        )
    }

    func reloadTableView() {
        playerTableView.reloadData()
    }

    func updatePickerView() {
        pickerView.reloadAllComponents()
    }
}

