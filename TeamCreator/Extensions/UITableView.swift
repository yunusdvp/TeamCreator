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
    
    func dequeCell<T: UITableViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {

            guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
                fatalError("Failed to dequeue cell with identifier: \(cellType.identifier). Ensure that the cell is registered and the identifier is correct.")
            }
            return cell
        }}
