//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    @IBOutlet private weak var galleryTableView: UITableView!
    
    private var isReachedBottom = false
    var pageNumber = 1
    private var photos: [Photo] = []
    private var currentIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        appendPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToIndexPath()
    }
    
    private func registerXib() {
        let cellNibName = UINib(nibName: GalleryTableViewCell.identifier,
                                bundle: nil)
        galleryTableView.register(cellNibName,
                                  forCellReuseIdentifier: GalleryTableViewCell.identifier)
    }
    
    private func appendPhotos() {
        loadPhotosFromServer(pageNumber: pageNumber) { photos in
            guard let photos = photos else {
                DispatchQueue.main.async { [weak self] in
                    self?.displaySpinnerView(false)
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.photos.append(contentsOf: photos)
                self.galleryTableView.reloadData()
                self.pageNumber += 1
            }
        }
    }
    
    private func scrollToIndexPath() {
        guard let indexPath = currentIndexPath else { return }
        galleryTableView.scrollToRow(at: indexPath,
                                     at: .middle,
                                     animated: true)
    }
    
    private func displaySpinnerView(_ isBottom: Bool = true) {
        if isBottom {
            galleryTableView.createBottomSpinnerView()
        } else {
            galleryTableView.tableFooterView = nil
        }
        isReachedBottom = isBottom
        galleryTableView.isScrollEnabled = !isBottom
    }

}

// MARK: UITableViewDataSource
extension GalleryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceWidth = Float(UIScreen.main.bounds.size.width)
        guard let height = photos[indexPath.row].photoHeightForDevice(deviceWidth)
        else { return 0 }
        let cellHeight = CGFloat(height)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: GalleryTableViewCell.identifier,
                                     for: indexPath) as? GalleryTableViewCell
        else { return UITableViewCell() }
        cell.configure(user: .none, photo: .none)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension GalleryViewController: UITableViewDelegate, ImageLoadable {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?
                .instantiateViewController(withIdentifier: DetailViewController.identifier)
                as? DetailViewController
        else { return }
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.photos = photos
        detailViewController.pageNumber = pageNumber
        detailViewController.currentIndexPath = indexPath
        detailViewController.delegate = self
        present(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let cell = cell as? GalleryTableViewCell,
              let user = photos[indexPath.row].user?.name,
              let url = photos[indexPath.row].urls?.regular
        else { return }
        
        loadImageFromURL(url: url) { (image) in
            cell.configure(user: user, photo: image)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isReachedBottom { return }
        
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.contentSize.height
        let distanceFromBottom = scrollViewHeight - contentYOffset
        
        if distanceFromBottom < height {
            displaySpinnerView()
            appendPhotos()
        }
    }

}

extension GalleryViewController: ScrollDelegate {
    
    func send(photos: [Photo]) {
        self.photos = photos
        galleryTableView.reloadData()
    }
    
    func scrollToIndexPath(at: IndexPath) {
        currentIndexPath = at
    }
    
}
