//
//  UIImageView+.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

extension UIImageView {
    
    /// image load될때 transition애니매이션
    func transition(toImage image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.image = image
                          },
                          completion: nil)
    }
    
}
