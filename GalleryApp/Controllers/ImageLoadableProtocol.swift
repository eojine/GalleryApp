//
//  ImageLoadableProtocol.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

protocol ImageLoadable: UIViewController {
    func loadImageFromURL(url: String,
                          completion: @escaping (UIImage) -> ())
    func showErrorAlert(error: NetworkError)
}

extension ImageLoadable {
    
    func loadImageFromURL(url: String,
                          completion: @escaping (UIImage) -> ()) {
        ImageCacheService.shared.load(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                self.showErrorAlert(error: error)
            }
        }
    }
    
    func showErrorAlert(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.showSimpleAlert(title: "Error!",
                                  message: error.errorToString())
        }
    }
    
}
