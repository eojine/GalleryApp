//
//  DataLoadable.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

protocol DataLoadable {
    func loadPhotosFromServer(pageNumber: Int,
                              search: String?,
                              completion: @escaping (Result<[Photo], NetworkError>) -> ())
}

extension DataLoadable {
    
    func loadPhotosFromServer(pageNumber: Int,
                              search: String?,
                              completion: @escaping (Result<[Photo], NetworkError>) -> ()) {
        switch search {
        case let .some(search) where !search.isEmpty:
            SearchService.shared.get(page: pageNumber, search: search) { result in
                switch result {
                case .success(let result):
                    guard let photos = result.photos else {
                        // Search요청을 보내고 데이터를 받았지만, photos가 없을 때
                        completion(.failure(.invalidResponse))
                        return
                    }
                    completion(.success(photos))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        default:
            PhotoService.shared.get(page: pageNumber) { result in
                switch result {
                case .success(let photos):
                    completion(.success(photos))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
