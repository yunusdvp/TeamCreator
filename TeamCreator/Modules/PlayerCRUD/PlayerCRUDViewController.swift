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
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlayerCRUDViewModel()
        viewModel?.delegate = self
        print(SelectedSportManager.shared.selectedSport as Any)
        registerCells()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker.delegate = self
        setupTapGesture()
      //  print(SelectedSportManager.shared.selectedSport)

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
            cell?.onImageTapped = { [weak self] in
                self?.openImagePicker()
            }
            return cell ?? UITableViewCell()
        case .playerName:
            let cell = tableView.dequeueCell(with: PlayerNameTableViewCell.self, for: indexPath)
            cell?.onNameChange = { [weak self] name in
                self?.viewModel?.updatePlayerName(name)
            }
            return cell ?? UITableViewCell()
        case .playerGender:
            let cell = tableView.dequeueCell(with: GenderTableViewCell.self, for: indexPath)
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
            let cell = tableView.dequeueCell(with: PlayerOtherPropertyTableViewCell.self, for: indexPath)
            cell?.viewModel = viewModel
            return cell ?? UITableViewCell()
        case .playerAddButton:
            let cell = tableView.dequeueCell(with: AddButtonTableViewCell.self, for: indexPath)
            cell?.onAddButtonTapped = { [weak self] in
                self?.viewModel?.addPlayerToFirebase { result in
                    switch result {
                    case .success:
                        print("Player successfully added")
                    case .failure(let error):
                        print("Error adding player: \(error.localizedDescription)")
                    }
                }
            }
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 20 : 0
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
                cell.profileImageView.image = selectedImage
            }
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                viewModel?.updatePlayerImageData(imageData)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}



