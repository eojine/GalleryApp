//
//  SearchService.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/12.
//

import Foundation

class SearchService: Requestable {
    
    typealias NetworkData = Search
    static let shared = SearchService()
    private init() {}
    
    func get(page: Int,
             search: String,
             completion: @escaping (Result<NetworkData, NetworkError>) -> Void) {
        let photoEndpoint: PhotoEndpoint = .get(page: page, search: search)
        request(photoEndpoint) { result in
            completion(result)
        }
    }
    
}
