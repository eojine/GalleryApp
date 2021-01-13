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
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    weak var delegate: SendDataDelegate?
    var photos: [Photo]?
    var currentIndexPath: IndexPath?
    var pageNumber: Int?
    var searchText: String?
    
    private var isLastPage = false
    private var displayAlert = false
    private var isFirstCallViewDidLayoutSubviews = true
    
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToIndexPath()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    // MARK: - IBActions
    
    @IBAction private func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        guard let indexPath = currentIndexPath,
              let photos = photos,
              let page = pageNumber else { return }
        delegate?.send(photos: photos, pageNumber: page)
        delegate?.scrollToIndexPath(at: indexPath)
    }
    
    // MARK: - Methods
    
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
    
}

// MARK: DataLoadable

extension DetailViewController: DataLoadable {
    
    private func appendPhotos() {
        guard let pageNumber = pageNumber else { return }
        loadPhotosFromServer(pageNumber: pageNumber,
                             search: searchText) { [weak self] result in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self?.displayPhotos(photos)
                }
            case .failure(let error):
                self?.isLastPage = true
                DispatchQueue.main.async {
                    self?.showErrorAlert(error: error)
                }
            }
        }
    }
    
    /// 받아온 photos 뿌려주고, pageNumber올리는 함수
    private func displayPhotos(_ photos: [Photo]) {
        self.photos?.append(contentsOf: photos)
        detailCollectionView.reloadData()
        pageNumber? += 1
        isLastPage = false
    }
    
    private func showErrorAlert(error: NetworkError) {
        if displayAlert { return }
        displayAlert = true
        showSimpleAlert(title: "Error!",
                        message: error.errorToString()) { [weak self] in
            self?.displayAlert = false
        }
    }
    
}

// MARK: UICollectionViewDataSource

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

// MARK: UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailCollectionViewCell,
              let photos = photos,
              let user = photos[indexPath.item].user?.name,
              let url = photos[indexPath.item].urls?.raw
        else { return }
        
        let width = Int(UIScreen.main.bounds.width)
        let dpr = Int(UIScreen.main.scale)
        ImageCacheService.shared.load(url: url,
                                      width: width,
                                      dpr: dpr) { result in
            switch result {
            case .success(let image):
                cell.configure(user: user, photo: image)
            default:
                break
            }
        }
        
        currentIndexPath = indexPath
        
        if isBottom(indexPath, photos) {
            appendPhotos()
        }
    }
    
    private func isBottom(_ indexPath: IndexPath,
                          _ photos: [Photo])  -> Bool {
        return indexPath.item + 1 == photos.count && !isLastPage
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: height)
    }
    
}
