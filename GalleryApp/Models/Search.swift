//
//  Search.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/12.
//

import Foundation

struct Search: Codable {
    let total: Int?
    let totalPages: Int?
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case photos = "results"
    }
}
