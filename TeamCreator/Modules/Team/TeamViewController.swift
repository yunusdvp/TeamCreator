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
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    

    override func viewDidLoad() {
            super.viewDidLoad()
            fetchStadiumWeather()
        }

        @objc private func fetchStadiumWeather() {
            // JSON dosyasından stadyum verisini oku
            if let path = Bundle.main.path(forResource: "turkey_sports_facilities", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let facilities = try JSONDecoder().decode(TurkeySportsFacilities.self, from: data)
                    
                    // Belirli bir stadyumu seçelim (örneğin "Vodafone Park")
                    if let selectedStadium = facilities.stadiums.first(where: { $0.name == "Vodafone Park" }) {
                        let lat = selectedStadium.latitude
                        let lon = selectedStadium.longitude
                        
                        self.stadiumLabel.text = selectedStadium.name // Stadyum adını label'a atıyoruz
                        
                        // Hava durumu verisini çekmek için NetworkManager'ı kullan
                        NetworkManager.shared.fetchWeather(lat: lat, lon: lon) { [weak self] result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let weatherResponse):
                                    self?.weatherLabel.text = " \(weatherResponse.weather.first?.description ?? "N/A")"
                                    self?.tempatureLabel.text = " \(weatherResponse.main.temp)°C"
                                
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
                        // Eğer stadyum bulunamazsa
                        self.stadiumLabel.text = "Stadium not found"
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
    }
