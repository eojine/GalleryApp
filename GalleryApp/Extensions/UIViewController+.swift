//
//  UIViewController+.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/10.
//

import UIKit

extension UIViewController {
    
    /// OK만 있는 Alert 생성하는 함수
    func showSimpleAlert(title: String,
                         message: String,
                         completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: completion)
    }
    
}
