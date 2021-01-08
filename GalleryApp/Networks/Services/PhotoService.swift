//
//  PhotoService.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

class PhotoService: Requestable {
    
    typealias NetworkData = Photo
    static let shared = PhotoService()
    private init() {}
    
    var issueEndpoint: IssueEndpoint = .get
    
    func getAll(completion: @escaping ([Issue]) -> Void) {
        issueEndpoint = .get
        request(issueEndpoint) { result in
            switch result {
            case .networkSuccess(let data):
                guard let issues = data.resResult.data else { return }
                completion(issues)
            case .networkError(let error):
                print(error)
            case .networkFail:
                print("Network Fail!!!!")
            }
        }
    }
    
}
