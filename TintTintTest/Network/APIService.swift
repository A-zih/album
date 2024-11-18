//
//  APIService.swift
//  TintTintTest
//
//  Created by 陳冠志 on 2024/11/15.
//

import Foundation
import Alamofire
import UIKit

class APIService {
    static let shared = APIService()
    private let baseURL = "https://jsonplaceholder.typicode.com/photos"
    
    private init() {}
    
    func fetchImages(page: Int, limit: Int, completion: @escaping ([Photo]?, Error?) -> Void) {
        let params: Parameters = [
            "_page": page,
            "_limit": limit
        ]
        
        AF.request(baseURL, parameters: params).responseDecodable(of: [Photo].self) { response in
            switch response.result {
            case .success(let photos):
                completion(photos, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping(UIImage?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let image = UIImage(data: data)
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
