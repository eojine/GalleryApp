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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        galleryImageView.image = nil
        titleLabel.text = ""
        dropShadow()
    }
    
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
    
    private func dropShadow() {
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shadowRadius = 5.0
        titleLabel.layer.shadowOpacity = 0.4
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}
