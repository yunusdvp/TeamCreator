//
//  TextField.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 8.08.2024.
//

import Foundation
import UIKit
class NoPasteTextField: UITextField {

    // Yapıştırma işlemini devre dışı bırakmak için canPerformAction metodunu override ediyoruz
    override func canPerformAction( _ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_ :)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
