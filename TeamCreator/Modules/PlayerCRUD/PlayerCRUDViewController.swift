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
    
    //    let playerRepository = NetworkManager.shared.playerRepository
    //    let imageStorage = NetworkManager.shared.imageStorage
    //
    //    let player1 = Player(id: nil, name: "Ceren",age: 20,position: "forward",skillRating: 100,gender: "male",profilePhotoURL: nil)
    //
    //    let image1 = UIImage(named: "fc")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlayerCRUDViewModel()
        viewModel?.delegate = self
        
        registerCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        imagePicker.delegate = self
        
        //        playerRepository.addPlayer(player: player1, image: image1) { result in
        //            switch result {
        //            case .success:
        //                print("Oyuncu eklendi")
        //            case .failure(let error):
        //                print("Hata eklenemedi \(error.localizedDescription)")
        //            }
        //        }
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
        case .playerPozition:
                   guard let cell = tableView.dequeueCell(with: PozitionTableViewCell.self, for: indexPath) else {
                       return UITableViewCell()
                   }
                   cell.positions = viewModel.getPositions()
                   cell.selectedPosition = viewModel.getSelectedPosition()
                   cell.viewModel = viewModel  // ViewModel'i doğrudan ata
                   cell.onPositionSelected = { [weak self] position in
                       self?.viewModel?.setSelectedPosition(position)
                   }
                   return cell
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


extension PlayerCRUDViewController: PlayerCRUDViewModelDelegate {
    func fetchData() {
        viewModel?.fetchData()
    }
}

