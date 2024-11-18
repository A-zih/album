//
//  Photo.swift
//  TintTintTest
//
//  Created by 陳冠志 on 2024/11/15.
//

import Foundation

class Photo: Codable {
    var albumID: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailURL: String?
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id
        case title
        case url
        case thumbnailURL = "thumbnailUrl"
    }
}
