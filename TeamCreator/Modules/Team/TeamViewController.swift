//
//  TeamViewController.swift
//  TeamCreator
//
//  Created by Giray Aksu on 2.08.2024.
//

/* import UIKit

class TeamViewController: UIViewController {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStadiumWeather()
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
    }
    
    @objc private func fetchStadiumWeather() {
        // JSON dosyasından stadyum verisini oku
        if let path = Bundle.main.path(forResource: "turkey_sports_facilities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let facilities = try JSONDecoder().decode(TurkeySportsFacilities.self, from: data)
                
                // Belirli bir stadyumu seçelim (örneğin "Vodafone Park")
                if let selectedStadium = facilities.stadiums.first(where: { $0.name == "Şükrü Saracoğlu Stadyumu" }) {
                    let lat = selectedStadium.latitude
                    let lon = selectedStadium.longitude
                    
                    self.stadiumLabel.text = selectedStadium.name // Stadyum adını label'a atıyoruz
                    
                    // Hava durumu verisini çekmek için NetworkManager'ı kullan
                    NetworkManager.shared.fetchWeather(lat: lat, lon: lon) { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let weatherResponse):
                                self?.weatherLabel.text = " \(weatherResponse.weather.first?.description ?? "N/A")"
                                
                                // Sıcaklık değerini tam sayı olarak al
                                let roundedTemperature = Int(weatherResponse.main.temp)
                                self?.tempatureLabel.text = "\(roundedTemperature)"
                                
                                if let conditionName = weatherResponse.weather.first?.conditionName {
                                    self?.weatherImage.image = UIImage(systemName: conditionName)
                                } else {
                                    self?.weatherImage.image = UIImage(systemName: "questionmark")
                                }
                            
                            case .failure(let error):
                                print("Error fetching weather data: \(error.localizedDescription)")
                                self?.weatherLabel.text = "Error: \(error.localizedDescription)"
                                self?.weatherImage.image = UIImage(systemName: "exclamationmark.triangle")
                            }
                        }
                    }
                } else {
                    self.stadiumLabel.text = "Stadium not found"
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
    }
} */

import UIKit

class TeamViewController: UIViewController {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    private var viewModel = TeamViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.fetchStadiumWeather(for: "Vodafone Park")
    }

    private func setupBindings() {
        viewModel.onWeatherDataFetched = { [weak self] weatherResponse in
            DispatchQueue.main.async {
                self?.updateUI(with: weatherResponse)
            }
        }

        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(errorMessage)
            }
        }
    }

    private func updateUI(with weatherResponse: WeatherResponse) {
        stadiumLabel.text = viewModel.selectedStadium?.name ?? "Unknown Stadium"
        weatherLabel.text = weatherResponse.weather.first?.description ?? "N/A"
        tempatureLabel.text = "\(Int(weatherResponse.main.temp))"
        
        if let conditionName = weatherResponse.weather.first?.conditionName {
            weatherImage.image = UIImage(systemName: conditionName)
        } else {
            weatherImage.image = UIImage(systemName: "questionmark")
        }
    }

    private func showError(_ message: String) {
        stadiumLabel.text = "Error"
        weatherLabel.text = message
        weatherImage.image = UIImage(systemName: "exclamationmark.triangle")
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        // Bu kısımda segment seçimine göre takım değiştirilir
    }
}
