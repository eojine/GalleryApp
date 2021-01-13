//
//  Displayable.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/13.
//

import UIKit

protocol Displayable {
    func displayImageWithActivityIndicator(activityIndicator: UIActivityIndicatorView,
                                           imageView: UIImageView,
                                           image: UIImage?)
    func displayLabelWithDropShadow(titleLabel: UILabel)
}

extension Displayable {
    
    func displayImageWithActivityIndicator(activityIndicator: UIActivityIndicatorView,
                                           imageView: UIImageView,
                                           image: UIImage?) {
        if let image = image {
            // 이미지가 있다면 이미지뷰에 이미지 넣고, stopAnimating
            imageView.transition(toImage: image)
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            imageView.image = .none
        }
    }
    
    func displayLabelWithDropShadow(titleLabel: UILabel) {
        titleLabel.dropShadow(radius: 5.0,
                              opacity: 0.4,
                              offset: CGSize(width: 2, height: 2))
    }
    
}
