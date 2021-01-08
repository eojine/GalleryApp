//
//  EndpointType.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

protocol EndpointType {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

extension EndpointType {
    var baseUrl: String {
        return ""
    }
}
