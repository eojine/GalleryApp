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
    
    func load(url: String,
              completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
        
        let cacheKey = NSString(string: url)
        
        guard let URL = URL(string: url) else { return }
        if let image = chachedImage(url: cacheKey) {
            completion(.success(image))
            return
        }
        
        URLSession.shared.dataTask(with: URL) { [weak self] (data, response, error) in
            guard let self = self,
                  let responseData = data,
                  let image = UIImage(data: responseData),
                  error == nil
            else {
                completion(.failure(.failedRequest))
                return
            }
            self.cacheImage(image, cacheKey, responseData.count)
            completion(.success(image))
        }.resume()
        
    }
    
    /// 이미지 캐시 체크
    private func chachedImage(url: NSString) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    // 이미지 캐싱
    private func cacheImage(_  image: UIImage,
                            _ key: NSString,
                            _ cost: Int) {
        cachedImages.setObject(image, forKey: key, cost: cost)
    }
    
}
