//
//  UIView.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 29.07.2024.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
