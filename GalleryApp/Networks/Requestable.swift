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

extension Requestable {
    func request(_ endpoint: EndpointType,
                 completion: @escaping (Result<NetworkData, NetworkError>) -> ()) {
        
        guard let url = URL(string: endpoint.path) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let headers = ["Content-Type": "application/json"]
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(.failedRequest))
                return 
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let datas = try decoder.decode(NetworkData.self,
                                               from: data)
                completion(.success(datas))
            } catch {
                completion(.failure(.failedParsing))
            }
            
        }.resume()
    }
}
