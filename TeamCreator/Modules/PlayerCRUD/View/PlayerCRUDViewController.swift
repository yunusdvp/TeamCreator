//
//  PlayerCRUDViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

protocol PlayerCRUDViewControllerProtocol: AnyObject {
    func reloadTableView()
}

final class PlayerCRUDViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    
    
    private let imagePicker = UIImagePickerController()
    
    var viewModel: PlayerCRUDViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    weak var delegate: PlayerListViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(SelectedSportManager.shared.selectedSport as Any)
        registerCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker.delegate = self
        setupTapGesture()
    }
    
    // MARK: - Setup Methods
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture() {
        view.endEditing(true)
    }
    
    private func registerCells() {
        tableView.register(cellType: PlayerImageTableViewCell.self)
        tableView.register(cellType: PlayerNameTableViewCell.self)
        tableView.register(cellType: GenderTableViewCell.self)
        tableView.register(cellType: PositionTableViewCell.self)
        tableView.register(cellType: PlayerOtherPropertyTableViewCell.self)
        tableView.register(cellType: AddButtonTableViewCell.self)
    }
    
    private func openImagePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func validateForm() -> Bool {
        guard let viewModel = viewModel else { return false }
        return viewModel.isFormValid()
    }
    private func showUpdateAlert(success: Bool, error: Error?) {
        let alertTitle = success ? "Success" : "Error"
        let alertMessage = success ? "Player successfully updated." : "Failed to update player: \(error?.localizedDescription ?? "Unknown error")"
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func addPlayer(completion: @escaping (Bool) -> Void) {
        self.delegate?.didUpdatePlayerList()
        navigateToPlayerList()
    }
    
    func navigateToPlayerList() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.didUpdatePlayerList()
    }

    func updatePlayer() {
        self.delegate?.didUpdatePlayerList()
        viewModel?.updatePlayerInFirebase { [weak self] result in
            switch result {
            case .success:
                
                self?.showUpdateAlert(success: true, error: nil)
                //self?.delegate?.didUpdatePlayerList()
                self?.navigateToPlayerList()
            case .failure(let error):
                self?.showUpdateAlert(success: false, error: error)
            }
        }
    }
    
}

// MARK: - Extension-UITableViewDataSource-UITableViewDelegate
extension PlayerCRUDViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.getCellTypeCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cellType = viewModel.getCellType(at: indexPath.section)
        switch cellType {
        case .playerImage:
            let cell = tableView.dequeueCell(with: PlayerImageTableViewCell.self, for: indexPath)
            if viewModel.player?.profilePhotoURL != nil {
                cell?.configure(with: viewModel.player?.profilePhotoURL)
            }
            cell?.onImageTapped = { [weak self] in
                self?.openImagePicker()
            }
            return cell ?? UITableViewCell()
        case .playerName:
            let cell = tableView.dequeueCell(with: PlayerNameTableViewCell.self, for: indexPath)
            if let name = viewModel.player?.name {
                cell?.playerNameTextField.text = name
            }
            cell?.onNameChange = { [weak self] name in
                self?.viewModel?.updatePlayerName(name)
            }
            return cell ?? UITableViewCell()
        case .playerGender:
            let cell = tableView.dequeueCell(with: GenderTableViewCell.self, for: indexPath)
            if let gender = viewModel.player?.gender {
                cell?.genderSegmentedControl.selectedSegmentIndex = (gender == "Male") ? 0 : 1
            }
            cell?.onGenderSelected = { [weak self] gender in
                self?.viewModel?.updatePlayerGender(gender)
            }
            return cell ?? UITableViewCell()
        case .playerPosition:
            guard let cell = tableView.dequeueCell(with: PositionTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.positions = viewModel.getPositionsForSelectedSport()
            cell.selectedPosition = viewModel.getSelectedPosition()
            cell.viewModel = viewModel
            cell.onPositionSelected = { [weak self] position in
                self?.viewModel?.setSelectedPosition(position)
            }
            return cell
        case .playerOtherProperty:
            guard let cell = tableView.dequeueCell(with: PlayerOtherPropertyTableViewCell.self, for: indexPath) else { return UITableViewCell() }
            if let skillRating = viewModel.player?.skillRating {
                cell.skillPointTextLabel.text = "\(skillRating)"
            }
            if let age = viewModel.player?.age {
                cell.ageTextField.text = "\(age)"
            }
            cell.viewModel = viewModel
            return cell
        case .playerAddButton:
            guard let cell = tableView.dequeueCell(with: AddButtonTableViewCell.self, for: indexPath) else { return UITableViewCell() }
            cell.updateButtonTitle()
            cell.onAddButtonTapped = { [weak self] in
                if (self?.viewModel?.player) != nil {
                    self?.viewModel?.updatePlayerInFirebase { result in
                        switch result {
                        case .success:
                            print("Player successfully updated")
                        case .failure(let error):
                            print("Error updating player: \(error.localizedDescription)")
                        }
                    }
                } else {
                    self?.viewModel?.addPlayerToFirebase { result in
                        switch result {
                        case .success:
                            print("Player successfully added")
                        case .failure(let error):
                            print("Error adding player: \(error.localizedDescription)")
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 150 : 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 10 : 0
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

// MARK: - PlayerCRUDViewControllerProtocol
extension PlayerCRUDViewController: PlayerCRUDViewControllerProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - PlayerCRUDViewModelDelegate
extension PlayerCRUDViewController: PlayerCRUDViewModelDelegate {
    func fetchData() {
        viewModel?.fetchData()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PlayerCRUDViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PlayerImageTableViewCell {
                cell.updateImage(with: selectedImage)
            }
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                viewModel?.updatePlayerImageData(imageData)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PlayerImageTableViewCell {
            cell.clearImage()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        openImagePicker()
    }
}
