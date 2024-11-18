//
//  AlbumViewModel.swift
//  TintTintTest
//
//  Created by 陳冠志 on 2024/11/15.
//

import Foundation
import Combine

enum LoadingState {
    case loading
    case finishedLoading
    case requestSuccess(paths: [IndexPath])
    case requestFail
}

class AlbumViewModel {
    @Published var state: LoadingState = .finishedLoading
    var photos: [Photo] = []
    private var currentPage = 1
    private var perPageCount = 60
    
    func fetchImages() {
        state = .loading
        APIService.shared.fetchImages(page: currentPage, limit: perPageCount) { [weak self] photos, err in
            guard let self = self else { return }
            self.state = .finishedLoading
            
            if let _ = err {
                self.state = .requestFail
            } else if let photos = photos {
                if !photos.isEmpty {
                    let currentCount = self.photos.count
                    self.photos.append(contentsOf: photos)
                    self.currentPage += 1
                    
                    let startIndex = currentCount
                    let endIndex = self.photos.count - 1
                    let indexPaths = (startIndex...endIndex).map { IndexPath(item: $0, section: 0)}
                    self.state = .requestSuccess(paths: indexPaths)
                } else {
                    //no more data
                }
            }
        }
    }
}
