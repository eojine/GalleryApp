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
        displayLabelWithDropShadow()
    }
    
    func configure(user: String?, photo: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = user
            self?.displayImageWithActivityIndicator(photo)
        }
    }
    
    private func displayImageWithActivityIndicator(_ image: UIImage?) {
        if let image = image {
            galleryImageView.transition(toImage: image)
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            galleryImageView.image = .none
        }
    }
    
    private func displayLabelWithDropShadow() {
        titleLabel.dropShadow(radius: 5.0,
                              opacity: 0.4,
                              offset: CGSize(width: 2, height: 2))
    }
    
}
