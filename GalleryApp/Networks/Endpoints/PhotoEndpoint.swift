//
//  PhotoEndpoint.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

enum PhotoEndpoint {
    case get(page: Int)
}

extension PhotoEndpoint: EndpointType {
    var path: String {
        switch self {
        case .get(let page):
            return baseUrl + "&page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .GET
        }
    }
    
}
