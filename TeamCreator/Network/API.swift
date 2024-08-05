//
//  API.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

final class API {
    
    static let shared = API()
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let apiKey = "2ba1df8d3db99a6508dad9c4223dc586"
    
    // Hava durumu verilerini almak için fonksiyon
    func getWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(result))
                print(result)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension API{
    
    func isConnectoInternet() -> Bool{
        Reachability.isConnectedToNetwork()
    }
    
}
