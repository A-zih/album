//
//  AlbumFooterView.swift
//  TintTintTest
//
//  Created by 陳冠志 on 2024/11/18.
//

import Foundation
import UIKit

class AlbumFooterView: UICollectionReusableView {
    static let identifier = "AlbumFooterView"
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "資料已加載完畢"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

