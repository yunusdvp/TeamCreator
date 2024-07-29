//
//  API.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 29.07.2024.
//

import Foundation

final class API {
    
    static let shared = API()
}

extension API{
    
    func isConnectoInternet() -> Bool{
        Reachability.isConnectedToNetwork()
    }
    
}
