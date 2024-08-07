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

final class PlayerCRUDViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let imagePicker = UIImagePickerController()
    
    var viewModel: PlayerCRUDViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlayerCRUDViewModel()
        viewModel?.delegate = self
        
        registerCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel?.fetchData()
        
        imagePicker.delegate = self
    }
    
    private func registerCells() {
        tableView.register(cellType: PlayerImageTableViewCell.self)
        tableView.register(cellType: PlayerNameTableViewCell.self)
        tableView.register(cellType: GenderTableViewCell.self)
        tableView.register(cellType: PozitionTableViewCell.self)
        tableView.register(cellType: AddButtonTableViewCell.self)
    }
    
    private func openImagePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
}

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
            return cell ?? UITableViewCell()
        case .playerGender:
            let cell = tableView.dequeueCell(with: GenderTableViewCell.self, for: indexPath)
            return cell ?? UITableViewCell()
        case .playerPozition:
            guard let cell = tableView.dequeueCell(with: PozitionTableViewCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            cell.positions = viewModel.getPositions()
            cell.selectedPosition = viewModel.getSelectedPosition()
            cell.onPositionSelected = { [weak self] position in
                self?.viewModel?.setSelectedPosition(position)
            }
            return cell
        case .playerAddButton:
            let cell = tableView.dequeueCell(with: AddButtonTableViewCell.self, for: indexPath)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 250 : 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 30 : 0
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


extension PlayerCRUDViewController: PlayerCRUDViewControllerProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension PlayerCRUDViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PlayerImageTableViewCell {
                cell.profileImageView.image = selectedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
