//
//  GalleryTableViewCell.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: GalleryTableViewCell.self)
    
    @IBOutlet private weak var galleryImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func configure(user: String, photo: UIImage) {
        galleryImageView.image = photo
        titleLabel.text = user
    }
    
    func activityStart() {
        activityIndicator.startAnimating()
    }
    
    func activityStop() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}
