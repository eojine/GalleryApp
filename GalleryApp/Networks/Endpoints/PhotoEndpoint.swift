//
//  PhotoEndpoint.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

enum PhotoEndpoint {
    case get(page: Int,
             search: String? = nil)
}

extension PhotoEndpoint: EndpointType {
    
    var path: String {
        switch self {
        case .get(let page, let search):
            var getURL = baseUrl
            if let search = search {
                getURL += "/search/photos?query=\(search)"
            } else {
                getURL += "/photos?page=\(page)"
            }
            return getURL + "&client_id=\(Token.accessToken)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .GET
        }
    }
    
}
