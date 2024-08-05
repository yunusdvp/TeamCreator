//
//  UITableView.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 1.08.2024.
//

import Foundation
import UIKit

extension UITableView {
    
    func register(cellType: UITableViewCell.Type) {
        register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
    }
}
