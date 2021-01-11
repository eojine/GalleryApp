//
//  UIViewController+.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/10.
//

import UIKit

extension UIViewController {
    
    func showSimpleAlert(title : String,
                         message : String,
                         complition: @escaping () -> ()) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: complition)
    }
    
}
