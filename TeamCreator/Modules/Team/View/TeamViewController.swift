//
//  TeamViewController.swift
//  TeamCreator
//
//  Created by Giray Aksu on 2.08.2024.
//

import UIKit

final class TeamViewController: BaseViewController {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var playersContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var confirmMatchButton: UIButton!
    
    var viewModel: TeamViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.loadInitialData()
    }

    private func setupBindings() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
    }

    private func updateUI(with weatherResponse: WeatherResponse) {
        stadiumLabel.text = "🏟️" + (viewModel.location ?? "Unknown Stadium")
        weatherLabel.text = weatherResponse.weather.first?.description ?? "N/A"
        tempatureLabel.text = "\(Int(weatherResponse.main.temp))"
        weatherImage.image = UIImage(systemName: weatherResponse.weather.first?.conditionName ?? "questionmark")
    }

    private func updateUIWithSelectedTeam() {
        viewModel.updateSelectedTeam(index: segmentedControl.selectedSegmentIndex)
    }

    private func showError(_ message: String) {
        stadiumLabel.text = "Error"
        weatherLabel.text = message
        weatherImage.image = UIImage(systemName: "exclamationmark.triangle")
    }

    private func setupDynamicFormation(formation: [[Player]]) {
        playersContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let backgroundImageView = UIImageView(frame: playersContainerView.bounds)
        backgroundImageView.image = UIImage(named: viewModel.backgroundImageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        playersContainerView.addSubview(backgroundImageView)
        
        let lineHeight: CGFloat = 80.0
        let radius: CGFloat = 30.0
        let containerWidth = playersContainerView.bounds.width

        for (lineIndex, linePlayers) in formation.enumerated() {
            let totalWidth = CGFloat(linePlayers.count) * (radius * 2 + 20) - 20
            var startX = (containerWidth - totalWidth) / 2
            let yPosition = CGFloat(lineIndex) * lineHeight

            for player in linePlayers {
                let playerView = UIView(frame: CGRect(x: startX, y: yPosition, width: radius * 2, height: radius * 2))
                playerView.layer.cornerRadius = radius
                playerView.layer.masksToBounds = true
                playerView.backgroundColor = .systemGreen

                let playerLabel = UILabel(frame: playerView.bounds)
                playerLabel.text = player.name
                playerLabel.textColor = .white
                playerLabel.textAlignment = .center
                playerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)

                playerView.addSubview(playerLabel)
                playersContainerView.addSubview(playerView)
                
                startX += radius * 2 + 20
            }
        }
    }

    private func updateDateAndTimeLabels(with date: Date) {
        dateLabel.text = viewModel.formattedDate(from: date)
        hoursLabel.text = viewModel.formattedTime(from: date)
    }

    @IBAction func confirmMatchButtonTapped(_ sender: UIButton) {
        viewModel.confirmMatch()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateUIWithSelectedTeam()
    }
    
    private func navigateToEntry() {
        guard let window = view.window else { return }

        let storyboard = UIStoryboard(name: "EntryViewController", bundle: nil)
        guard let entryVC = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as? EntryViewController else { return }

        let navigationController = UINavigationController(rootViewController: entryVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension TeamViewController: TeamViewModelDelegate {
    func didFetchWeatherData(_ weatherResponse: WeatherResponse) {
        DispatchQueue.main.async {
            self.updateUI(with: weatherResponse)
        }
    }

    func didFailWithError(_ error: String) {
        DispatchQueue.main.async {
            self.showError(error)
        }
    }

    func didUpdatePlayers(_ formation: [[Player]]) {
        DispatchQueue.main.async {
            self.setupDynamicFormation(formation: formation)
        }
    }

    func didCreateMatchSuccessfully() {
        let alert = UIAlertController(
            title: "Match Created",
            message: "Your match was successfully created. What would you like to do next?",
            preferredStyle: .alert
        )

        let mainMenuAction = UIAlertAction(title: "Go to Main Menu", style: .default) { [weak self] _ in
            self?.navigateToEntry()
        }

        let matchPreviewAction = UIAlertAction(title: "Match Preview", style: .default) { [weak self] _ in
            self?.confirmMatchButton.isHidden = true
        }

        alert.addAction(mainMenuAction)
        alert.addAction(matchPreviewAction)

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func didFailToCreateMatch(_ error: String) {
        showAlert("Error", error)
    }
}

