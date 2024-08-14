//
//  PlayerCRUDViewController.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 7.08.2024.
//

import UIKit

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
        
        registerCells()
        
        setupTableView()
        setupPickerView()
        
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
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func setupPickerView() {
        imagePicker.delegate = self
    }
    
    func validateForm() -> Bool {
        guard let viewModel = viewModel else { return false }
        return viewModel.isFormValid()
    }

    func addPlayer() {
        guard let viewModel = viewModel else { return }
        showLoading()
        navigateToPlayerList()
    }
    
    func navigateToPlayerList() {
        self.delegate?.didUpdatePlayerList()
        self.navigationController?.popViewController(animated: true)
        
    }
}
    // MARK: - Extension-UITableViewDataSource-UITableViewDelegate
    extension PlayerCRUDViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int { viewModel?.getCellTypeCount() ?? 0 }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let viewModel = viewModel else { return UITableViewCell() }
            let cellType = viewModel.getCellType(at: indexPath.section)
            switch cellType {
            case .playerImage:
                let cell = tableView.dequeCell(cellType: PlayerImageTableViewCell.self, indexPath: indexPath)
                if let profilePhotoURL = viewModel.player?.profilePhotoURL {
                    cell.configure(with: profilePhotoURL)
                }
                cell.onImageTapped = { [weak self] in
                    self?.viewModel?.delegate?.presentImagePicker()
                }
                return cell
            case .playerName:
                let cell = tableView.dequeCell(cellType: PlayerNameTableViewCell.self, indexPath: indexPath)
                if let name = viewModel.player?.name {
                    cell.playerNameTextField.text = name
                }
                cell.onNameChange = { [weak self] name in
                    self?.viewModel?.updatePlayerName(name)
                }
                return cell
            case .playerGender:
                let cell = tableView.dequeCell(cellType: GenderTableViewCell.self, indexPath: indexPath)
                if let gender = viewModel.player?.gender {
                    cell.genderSegmentedControl.selectedSegmentIndex = (gender == "Male") ? 0 : 1
                }
                cell.onGenderSelected = { [weak self] gender in
                    self?.viewModel?.updatePlayerGender(gender)
                }
                return cell
            case .playerPosition:
                let cell = tableView.dequeCell(cellType: PositionTableViewCell.self, indexPath: indexPath)
                
                cell.positions = viewModel.getPositionsForSelectedSport()
                cell.selectedPosition = viewModel.getSelectedPosition()
                cell.onPositionSelected = { [weak self] position in
                    self?.viewModel?.setSelectedPosition(position)
                }
                return cell
            case .playerOtherProperty:
                let cell = tableView.dequeCell(cellType: PlayerOtherPropertyTableViewCell.self, indexPath: indexPath)
                if let skillRating = viewModel.player?.skillRating {
                    cell.skillPointTextLabel.text = "\(skillRating)"
                }
                if let age = viewModel.player?.age {
                    cell.ageTextField.text = "\(age)"
                }
                cell.viewModel = viewModel
                return cell
            case .playerAddButton:
                        let cell = tableView.dequeCell(cellType: AddButtonTableViewCell.self, indexPath: indexPath)
                        cell.viewModel = viewModel
                        cell.delegate = self
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
            section == 1 ? UIView() : nil
        }
    }

// MARK: - PlayerCRUDViewControllerProtocol
extension PlayerCRUDViewController: PlayerCRUDViewModelDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showUpdateAlert(success: Bool, message: String) {
           hideLoading()
           let alert = UIAlertController(title: success ? "Success" : "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
               if success {
                   self?.navigateToPlayerList()
               }
           }))
           present(alert, animated: true, completion: nil)
       }
    
    func updatePlayerList() {
        hideLoading()
        navigateToPlayerList()
    }
    
    func presentImagePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
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
        presentImagePicker()
    }
}

extension PlayerCRUDViewController: AddButtonTableViewCellDelegate {
    func didTapAddButton(success: Bool) {
        addPlayer()
    }
}
