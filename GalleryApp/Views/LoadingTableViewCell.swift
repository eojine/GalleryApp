//
//  LoadingTableViewCell.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class LoadingTableViewCell: UITableViewCell {

    static let identifier = String(describing: LoadingTableViewCell.self)
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    func start() {
        activityIndicatorView.startAnimating()
    }
    
}
