//
//  Photo.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

struct Photo: Codable {
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let width: Int?
    let height: Int?
    let color: String?
    let blurHash: String?
    let likes: Int?
    let likedByUser: Bool?
    let description: String?
//    let user: User?
//    let currentUserCollections: [Current_user_collections]?
//    let urls: Urls?
//    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, color, likes, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blurHash = "blur_hash"
        case likedByUser = "liked_by_user"
//        case currentUserCollections = "current_user_collections"
    }
    
}
