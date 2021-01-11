//
//  UIImageView+.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

extension UIImageView {
    
    func transition(toImage image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.image = image
                          },
                          completion: nil)
    }
    
}
