//
//  ViewController.swift
//  TintTintTest
//
//  Created by 陳冠志 on 2024/11/15.
//

import UIKit

class ViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TintTint Test"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Next", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(nextBtn)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            nextBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextBtn.widthAnchor.constraint(equalToConstant: 100),
            nextBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapNext() {
        let vc = AlbumViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

