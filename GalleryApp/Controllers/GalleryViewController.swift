//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    @IBOutlet private weak var galleryTableView: UITableView!
    
    private var reachedBottom = false // 맨 밑에 닿았는지 체크
    private var pageNumber = 1
    private var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        appendPhotos()
    }
    
    private func registerXib() {
        let cellNibName = UINib(nibName: GalleryTableViewCell.identifier,
                                bundle: nil)
        galleryTableView.register(cellNibName,
                                  forCellReuseIdentifier: GalleryTableViewCell.identifier)
    }
    
    private func appendPhotos() {
        loadPhotosFromServer { photos in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.photos.append(contentsOf: photos)
                self.galleryTableView.reloadData()
                self.galleryTableView.tableFooterView = nil
                self.galleryTableView.isScrollEnabled = true
                self.reachedBottom = false
                self.pageNumber += 1
            }
        }
    }
    
    private func showErrorAlert(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.showSimpleAlert(title: "Error!",
                                  message: error.errorToString())
        }
    }
    
}

// MARK:- Networking
extension GalleryViewController {
    
    private func loadPhotosFromServer(completion: @escaping ([Photo]) -> ()) {
        PhotoService.shared.get(page: pageNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                completion(photos)
            case .failure(let error):
                self.showErrorAlert(error: error)
            }
        }
    }
    
    private func loadImageFromURL(url: String,
                                  completion: @escaping (UIImage) -> ()) {
        ImageCacheService.shared.load(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                self.showErrorAlert(error: error)
            }
        }
    }
    
}

// MARK: UITableViewDataSource
extension GalleryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceWidth = Float(UIScreen.main.bounds.size.width)
        guard let height = photos[indexPath.row].photoHeightForDevice(deviceWidth)
        else {
            return 0
        }
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
extension GalleryViewController: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if reachedBottom { return }
        
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.contentSize.height
        let distanceFromBottom = scrollViewHeight - contentYOffset
        
        if distanceFromBottom < height {
            reachedBottom = true
            galleryTableView.isScrollEnabled = false
            galleryTableView.createBottomSpinnerView()
            appendPhotos()
        }
    }

}
