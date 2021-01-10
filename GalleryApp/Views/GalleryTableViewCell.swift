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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropShadow()
    }
    
    func configure(user: String?, photo: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.galleryImageView.image = photo
            self.titleLabel.text = user
            self.displayActivityIndicator(photo)
        }
    }
    
    private func displayActivityIndicator(_ image: UIImage?) {
        if let image = image {
            galleryImageView.image = image
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            galleryImageView.image = .none
        }
    }
    
    private func dropShadow() {
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shadowRadius = 5.0
        titleLabel.layer.shadowOpacity = 0.4
        titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
}
