//
//  PlayerListViewModel.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import Foundation
final class PlayerListViewModel {
    
    enum PlayerListTableViewCell {
        case player
        case addButton
        
    }
    
    var celltypeList: [PlayerListTableViewCell]
    
    init() {
        self.celltypeList = [.player, .addButton]
    }

}


