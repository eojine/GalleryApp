//
//  Photo.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

struct Photo: Codable {
    let id: String?
    let width: Int?
    let height: Int?
    let urls: Urls?
    let user: User?
    
    struct Urls: Codable {
        let regular: String?
    }
    
    struct User: Codable {
        let name: String?
    }

}

extension Photo {
    
    func photoHeightForDevice(_ deviceWidth: Float) -> Float? {
        guard let width = self.width,
              let height = self.height else { return nil}
        
        let floatWidth = Float(width), floatHeight = Float(height)
        let resizedWidth = floatWidth * (deviceWidth / floatWidth)
        let resizedHeight = resizedWidth * floatHeight / floatWidth
        
        return resizedHeight
    }
    
}
