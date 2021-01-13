//
//  GalleryTableViewCell.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryTableViewCell: UITableViewCell, Displayable {
    
    static let identifier = String(describing: GalleryTableViewCell.self)
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var galleryImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = .none
        galleryImageView.image = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayLabelWithDropShadow(titleLabel: titleLabel)
    }
    
    // MARK: - Methods
    
    func configure(user: String?, photo: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = user
            self.displayImageWithActivityIndicator(activityIndicator: self.activityIndicator,
                                                   imageView: self.galleryImageView,
                                                   image: photo)
        }
    }
    
}
