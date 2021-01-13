//
//  DetailCollectionViewCell.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

final class DetailCollectionViewCell: UICollectionViewCell, Displayable {
    
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
        displayLabelWithDropShadow(titleLabel: titleLabel)
    }
    
    func configure(user: String?, photo: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = user
            self.displayImageWithActivityIndicator(activityIndicator: self.activityIndicator,
                                                   imageView: self.detailImageView,
                                                   image: photo)
        }
    }
    
}
