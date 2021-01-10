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

extension NetworkError {
    
    func errorToString() -> String {
        switch self {
        case .invalidURL:
            return "네트워크 URL을 확인해주세요"
        case .failedRequest:
            return "네트워크 환경을 확인해주세요"
        case .invalidResponse, .invalidData, .failedParsing:
            return "데이터 불러오기에 실패했습니다"
        }
    }
    
}
