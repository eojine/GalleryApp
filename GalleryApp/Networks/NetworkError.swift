//
//  NetworkError.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case failedRequest
    case failedParsing
}
