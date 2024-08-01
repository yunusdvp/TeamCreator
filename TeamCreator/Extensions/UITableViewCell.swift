//
//  UITableViewCell.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
