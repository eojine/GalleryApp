//
//  ImageLoadableProtocol.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

protocol ImageLoadable: UIViewController {
    func loadPhotosFromServer(pageNumber: Int,
                              search: String?,
                              completion: @escaping (Result<[Photo], NetworkError>) -> ())
}

extension ImageLoadable {
    
    func loadPhotosFromServer(pageNumber: Int,
                              search: String?,
                              completion: @escaping (Result<[Photo], NetworkError>) -> ()) {
        switch search {
        case let .some(search) where !search.isEmpty:
            SearchService.shared.get(page: pageNumber, search: search) { result in
                switch result {
                case .success(let result):
                    guard let photos = result.photos else {
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
