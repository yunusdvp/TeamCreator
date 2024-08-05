//
//  TeamViewController.swift
//  TeamCreator
//
//  Created by Giray Aksu on 2.08.2024.
//

import UIKit

class TeamViewController: UIViewController {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempatureLabel: UILabel!
 //   @IBOutlet weak var fetchWeatherButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherData()
        setupUI()
    }

    private func setupUI() {
  //      fetchWeatherButton.addTarget(self, action: #selector(fetchWeatherData), for: .touchUpInside)
    }

    @objc private func fetchWeatherData() {
        let lat = 41.0082
        let lon = 28.9784

        print("Fetching weather data...")
        NetworkManager.shared.fetchWeather(lat: lat, lon: lon) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    print("Weather data fetched successfully")
                    self?.weatherLabel.text = "Weather: \(weatherResponse.weather.first?.description ?? "N/A")"
                    self?.tempatureLabel.text = "Temperature: \(weatherResponse.main.temp)°C"
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                    self?.weatherLabel.text = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

