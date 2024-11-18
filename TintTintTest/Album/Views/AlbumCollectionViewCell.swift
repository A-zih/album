//
//  AlbumCollectionViewCell.swift
//  TintTintTest
//
//  Created by 陳冠志 on 2024/11/18.
//

import Foundation
import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumCell"
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(idLabel)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            idLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(id: Int, title: String, urlStr: String) {
        //設置id
        idLabel.text = String(id)
        //設置title
        titleLabel.text = title
        //設置圖片
        guard let url = URL(string: urlStr) else {
            imageView.image = nil
            imageView.backgroundColor = .black
            return
        }
        
        imageView.image = nil
        imageView.backgroundColor = .black
        
        //MARK: 可以使用Kingfisher緩存圖片進行優化
        APIService.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.backgroundColor = .clear
                self.imageView.image = image
            }
        }
    }
}
