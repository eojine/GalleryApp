//
//  ImageCache.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import Foundation
import UIKit

final class ImageCacheService {
    
    static let shared = ImageCacheService()
    private let cachedImages = NSCache<NSString, UIImage>()
    private init() { }
    
    func load(url: String,
              completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
        
        let cacheKey = NSString(string: url)
        guard let URL = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let image = chachedImage(url: cacheKey) {
            completion(.success(image))
            return
        }
        
        URLSession.shared.dataTask(with: URL) { [weak self] (data, response, error) in
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
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.failedParsing))
                return
            }
            
            self?.cachedImages.setObject(image, forKey: cacheKey, cost: data.count)
            completion(.success(image))
        }.resume()
        
    }
    
    /// 이미지 캐시 체크
    private func chachedImage(url: NSString) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
}
