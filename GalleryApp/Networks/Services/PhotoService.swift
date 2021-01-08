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
    
    var photoEndpoint: PhotoEndpoint = .get
    
    func getAll(completion: @escaping (Result<NetworkData, NetworkError>) -> Void) {
        photoEndpoint = .get
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
