//
//  EntryModule.swift
//  TeamCreator
//
//  Created by Yunus Emre ÖZŞAHİN on 2.08.2024.
//

import Foundation

final class EntryModule {
    
    static func createModule() -> EntryViewController {
        let view = EntryViewController()
        let coordinator = EntryCoordinator(viewcontroller: view)
        let viewModel = EntryViewModel(view: view)
        return view
    }
    
}
