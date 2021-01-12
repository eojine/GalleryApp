//
//  DetailViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

protocol SendDataDelegate: class {
    func scrollToIndexPath(at: IndexPath)
    func send(photos: [Photo], pageNumber: Int)
}

final class DetailViewController: UIViewController {
    
    static let identifier = String(describing: DetailViewController.self)
    
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    
    weak var delegate: SendDataDelegate?
    var photos: [Photo]?
    var currentIndexPath: IndexPath?
    var pageNumber: Int?
    var searchText: String?
    
    private var isLastPage = false
    private var isFirstCallViewDidLayoutSubviews = true
    
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
        guard let indexPath = currentIndexPath,
              let photos = photos,
              let page = pageNumber else { return }
        delegate?.send(photos: photos, pageNumber: page)
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
                                          at: .centeredHorizontally,
                                          animated: false)
        isFirstCallViewDidLayoutSubviews = false
    }
    
    private func appendPhotos() {
        guard let pageNumber = pageNumber else { return }
        loadPhotosFromServer(pageNumber: pageNumber,
                             search: searchText) { [weak self] photos in
            guard let resultPhotos = photos else {
                self?.isLastPage = true
                return
            }
            DispatchQueue.main.async {
                self?.displayPhotos(resultPhotos)
            }
        }
    }
    
    private func displayPhotos(_ photos: [Photo]) {
        self.photos?.append(contentsOf: photos)
        detailCollectionView.reloadData()
        pageNumber? += 1
        isLastPage = false
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
              let photos = photos,
              let user = photos[indexPath.item].user?.name,
              let url = photos[indexPath.item].urls?.regular
        else { return }
        
        loadImageFromURL(url: url) { image in
            cell.configure(user: user, photo: image)
        }
        
        currentIndexPath = indexPath
        
        if indexPath.item == photos.count - 1 && !isLastPage {
            appendPhotos()
        }
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
