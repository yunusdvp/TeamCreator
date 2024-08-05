//
//  PlayerCRUDViewController.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 1.08.2024.
//

import UIKit

class PlayerCRUDViewController: UIViewController {
    
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var agePickerView: UIPickerView!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var pozitionPickerView: UIPickerView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    private var viewModel = PlayerCRUDViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderSegmentedControl.selectedSegmentIndex = 0
        
        updateGenderLabel()
        configurePickerView()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        personImageView.isUserInteractionEnabled = true
        personImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func configurePickerView() {
        pozitionPickerView.delegate = self
        pozitionPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        agePickerView.delegate = self
        agePickerView.dataSource = self
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
    }
    
    @IBAction func addPlayerButtonClciked(_ sender: UIButton) {
        let selectedPosition = viewModel.getSelectedPosition()
        let selectedCountry = viewModel.getSelectedCountry()
        let selectedAge = viewModel.getSelectedAge()
        let selectedHeight = viewModel.getSelectedHeight()
        let selectedWeight = viewModel.getSelectedWeight()
        let personName = personNameLabel.text ?? ""
           
        print("Name: \(personName)")
        print("Selected position: \(selectedPosition)")
        print("Selected country: \(selectedCountry)")
        print("Selected age: \(selectedAge)")
        print("Selected height: \(selectedHeight)")
        print("Selected weight: \(selectedWeight)")
    }
    
    @objc func imageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
        
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        updateGenderLabel()
    }
    
    @IBAction func createOrUpdatedButtonTapped(_ sender: UIButton) {
    }
    

    private func updateGenderLabel() {
        let selectedGender = genderSegmentedControl.titleForSegment(at:genderSegmentedControl.selectedSegmentIndex)
        
    }
}


extension PlayerCRUDViewController: UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            personImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pozitionPickerView {
            return viewModel.getPositions().count
        } else if pickerView == countryPickerView {
            return viewModel.getCountries().count
        } else if pickerView == agePickerView {
            return viewModel.getAges().count
        } else if pickerView == heightPickerView {
            return viewModel.getHeights().count
        } else if pickerView == weightPickerView {
            return viewModel.getWeights().count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pozitionPickerView {
            return viewModel.getPositions()[row]
        } else if pickerView == countryPickerView {
            return viewModel.getCountries()[row]
        } else if pickerView == agePickerView {
            return String(viewModel.getAges()[row])
        } else if pickerView == heightPickerView {
            return String(viewModel.getHeights()[row])
        } else if pickerView == weightPickerView {
            return String(viewModel.getWeights()[row])
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pozitionPickerView {
            let selectedPosition = viewModel.getPositions()[row]
            viewModel.setSelectedPosition(selectedPosition)
            print("Selected position: \(selectedPosition)")
        } else if pickerView == countryPickerView {
            let selectedCountry = viewModel.getCountries()[row]
            viewModel.setSelectedCountry(selectedCountry)
            print("Selected country: \(selectedCountry)")
        } else if pickerView == agePickerView {
            let selectedAge = viewModel.getAges()[row]
            viewModel.setSelectedAge(selectedAge)
            print("Selected age: \(selectedAge)")
        } else if pickerView == heightPickerView {
            let selectedHeight = viewModel.getHeights()[row]
            viewModel.setSelectedHeight(selectedHeight)
            print("Selected height: \(selectedHeight)")
        } else if pickerView == weightPickerView {
            let selectedWeight = viewModel.getWeights()[row]
            viewModel.setSelectedWeight(selectedWeight)
            print("Selected weight: \(selectedWeight)")
        }
    }
}
