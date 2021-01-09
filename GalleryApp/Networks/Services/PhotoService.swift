//
//  PhotoService.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

class PhotoService: Requestable {
    
    typealias NetworkData = [Photo]
    static let shared = PhotoService()
    private init() {}
    
    func get(page: Int,
             completion: @escaping (Result<NetworkData, NetworkError>) -> Void) {
        let photoEndpoint: PhotoEndpoint = .get(page: page)
        request(photoEndpoint) { result in
            completion(result)
//            switch result {
//            case .success(let data):
//                completion(data)
//            case .failure(_):
//                print("fail")
//            }
        }
    }
    
}
