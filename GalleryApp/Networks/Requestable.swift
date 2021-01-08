//
//  Requestable.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation

protocol Requestable {
    associatedtype NetworkData: Codable
    func request(_ endpoint: EndpointType,
                 completion: @escaping (Result<NetworkData, NetworkError>) -> ())
}
