//
//  UILabel+.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

extension UILabel {
    
    /// label에 shadow 생성
    func dropShadow(radius: CGFloat, opacity: Float, offset: CGSize) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
    }
    
}
