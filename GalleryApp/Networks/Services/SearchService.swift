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
            switch result {
            case .success(let data):
                if data.totalPages ?? 0 < page {
                    completion(.failure(.invalidPageNumber))
                    return
                }
            default:
                break
            }
            completion(result)
        }
    }
    
}
