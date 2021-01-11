//
//  DetailCollectionViewCell.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: DetailCollectionViewCell.self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = .none
        detailImageView.image = .none
    }
    
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
            detailImageView.transition(toImage: image)
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            detailImageView.image = .none
        }
    }
    
    private func displayLabelWithDropShadow() {
        titleLabel.dropShadow(radius: 5.0,
                              opacity: 0.4,
                              offset: CGSize(width: 2, height: 2))
    }
    
}
