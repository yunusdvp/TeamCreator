//
//  MatchCreateViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 5.08.2024.
//

import UIKit

protocol MatchCreateViewControllerProtocol: AnyObject {
    func reloadTableView()
    func navigateToAnyWhere()
}

class MatchCreateViewController: BaseViewController {
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var locationTextField: UITextField!
    @IBOutlet private weak var playerTableView: UITableView!
    
    var viewModel: MatchCreateViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    private var pickerView: UIPickerView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MatchCreateViewModel()
        prepareTableView()
        preparePickerView()
        viewModel.fetchLocations()
        let selectedSport = SelectedSportManager.shared.selectedSport?.rawValue ?? ""
        viewModel.fetchPlayers(sporType: selectedSport) { result in
                    switch result {
                    case .success(let players):
                        print("Oyuncular başarıyla getirildi: \(players)")
                        
                    case .failure(let error):
                        print("Oyuncular getirilirken hata oluştu: \(error.localizedDescription)")
                    }
                }
    }
    
    private func prepareTableView() {
        playerTableView.delegate = self
        playerTableView.dataSource = self
        playerTableView.register(UINib(nibName: "PlayerListTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerListTableViewCell")
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
}

extension MatchCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getPlayersCount(for: section)}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTableViewCell", for: indexPath) as? PlayerListTableViewCell else {
            return UITableViewCell()
        }
        let player = viewModel.getPlayer(at: indexPath.row)
        cell.configure(with: player)
        return cell
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
    func navigateToAnywhere() {

    }
    
    func reloadTableView() {
        playerTableView.reloadData()
    }
    
    func updatePickerView() {
        pickerView.reloadAllComponents()
    }
}

