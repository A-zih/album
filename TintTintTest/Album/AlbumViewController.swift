//
//  AlbumViewController.swift
//  TintTintTest
//
//  Created by 陳冠志 on 2024/11/15.
//

import Foundation
import UIKit
import Combine

class AlbumViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.register(AlbumFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: AlbumFooterView.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private var viewModel = AlbumViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var allowFetchingMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        viewModel.fetchImages()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    break
                case .finishedLoading:
                    break
                case .requestSuccess(let paths):
                    if viewModel.noMoreData {
                        self.collectionView.reloadData()
                        self.allowFetchingMore = false
                    } else {
                        /// 使用insert而不是reload，避免畫面閃爍
                        self.collectionView.performBatchUpdates {
                            self.collectionView.insertItems(at: paths)
                        }
                        self.allowFetchingMore = true
                    }
                case .requestFail(let err):
                    self.allowFetchingMore = true
                    debugPrint("發生錯誤: ", err)
                }
            }
            .store(in: &cancellables)
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        let id = viewModel.photos[indexPath.row].id ?? 0
        let title = viewModel.photos[indexPath.row].title ?? ""
        let url = viewModel.photos[indexPath.row].thumbnailURL ?? ""
        cell.configure(id: id, title: title, urlStr: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let itemWidth = collectionView.frame.width / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel.noMoreData {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AlbumFooterView.identifier, for: indexPath) as? AlbumFooterView else {
                return UICollectionReusableView()
            }
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension AlbumViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let bottomY = contentHeight - frameHeight
        let threshold = 200.0
        
        if offsetY > bottomY - threshold && allowFetchingMore {
            allowFetchingMore = false
            viewModel.fetchImages()
        }
    }
}
