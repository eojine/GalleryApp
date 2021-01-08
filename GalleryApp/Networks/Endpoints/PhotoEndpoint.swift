//
//  PhotoEndpoint.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

enum PhotoEndpoint {
    case get
}

extension PhotoEndpoint: EndpointType {
    var path: String {
        switch self {
        case .get:
            return baseUrl
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .GET
        }
    }
    
}
