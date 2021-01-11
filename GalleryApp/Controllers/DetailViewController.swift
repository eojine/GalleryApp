//
//  DetailViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

protocol ScrollDelegate: class {
    func scrollToIndexPath(at: IndexPath)
}

final class DetailViewController: UIViewController {
    
    static let identifier = String(describing: DetailViewController.self)
    
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    
    var photos: [Photo]?
    var currentIndexPath: IndexPath?
    var isFirstCallViewDidLayoutSubviews = true
    weak var delegate: ScrollDelegate?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToIndexPath()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    @IBAction private func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        guard let indexPath = currentIndexPath else { return }
        delegate?.scrollToIndexPath(at: indexPath)
    }
    
    private func registerXib() {
        let cellNibName = UINib(nibName: DetailCollectionViewCell.identifier,
                                bundle: nil)
        detailCollectionView.register(cellNibName,
                                      forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
    }
    
    private func scrollToIndexPath() {
        guard let indexPath = currentIndexPath,
              isFirstCallViewDidLayoutSubviews
              else { return }
        detailCollectionView.scrollToItem(at: indexPath,
                                          at: .right,
                                          animated: false)
        isFirstCallViewDidLayoutSubviews = false
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let photoCount = photos?.count else { return 0 }
        return photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier,
                                     for: indexPath) as? DetailCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(user: .none, photo: .none)
        return cell
    }
    
}

extension DetailViewController: UICollectionViewDelegate, ImageLoadable {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? DetailCollectionViewCell,
              let photo = photos?[indexPath.row],
              let user = photo.user?.name,
              let url = photo.urls?.regular
        else { return }
        
        loadImageFromURL(url: url) { (image) in
            cell.configure(user: user, photo: image)
        }
        
        currentIndexPath = indexPath
    }
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: height)
    }
    
}
