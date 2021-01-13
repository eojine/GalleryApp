//
//  SearchService.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/12.
//

import Foundation

final class SearchService: Requestable {
    
    typealias NetworkData = Search
    static let shared = SearchService()
    private init() { }
    
    func get(page: Int,
             search: String,
             completion: @escaping (Result<NetworkData, NetworkError>) -> Void) {
        let photoEndpoint: PhotoEndpoint = .get(page: page, search: search)
        request(photoEndpoint) { result in
            switch result {
            case .success(let data):
                // 리퀘스트에 성공했지만, 필요한 데이터가 없을 때
                guard let totalPages = data.totalPages else {
                    completion(.failure(.invalidResponse))
                    return
                }
                // 전체 페이지가 검색한 페이지보다 작을 때
                if totalPages < page {
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
