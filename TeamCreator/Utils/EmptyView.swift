//
//  EmptyView.swift
//  TeamCreator
//
//  Created by Giray Aksu on 13.08.2024.
//

import UIKit

class EmptyView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No matches available."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(messageLabel)
        
        // Label'ı merkezi hale getirmek için kısıtlamalar ekleyin
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

