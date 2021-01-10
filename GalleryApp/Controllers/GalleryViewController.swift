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
    private var hasNextPage = false // 다음 페이지를 가지는지 체크
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
    
    private func showErrorAlert(error: NetworkError) {
        print("showAlertError~~~!")
        switch error {
        case .invalidURL:
            return
        case .failedRequest:
            return
        case .invalidResponse, .invalidData, .failedParsing:
            return
        }
    }
    
}

// MARK:- Methods: PhotoListNetwork
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
    
    private func appendPhotos() {
        loadPhotosFromServer { photos in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.photos.append(contentsOf: photos)
                self.galleryTableView.reloadData()
                self.pageNumber += 1
                self.galleryTableView.tableFooterView = nil
                self.reachedBottom = false
            }
        }
    }
    
}

// MARK:- Methods: image URL Network
extension GalleryViewController {
    
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
    
    private func showCellImage(url: String,
                               user: String,
                               cell: GalleryTableViewCell) {
        cell.activityStart()
        loadImageFromURL(url: url) { (image) in
            DispatchQueue.main.async {
                cell.configure(user: user, photo: image)
                cell.activityStop()
            }
        }
    }
    
}

// MARK: UITableViewDataSource
extension GalleryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceWidth = Float(UIScreen.main.bounds.size.width)
        guard let height = photos[indexPath.row]
                .photoHeightForDevice(deviceWidth)
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
                                     for: indexPath) as? GalleryTableViewCell,
              let user = photos[indexPath.row].user?.name,
              let url = photos[indexPath.row].urls?.small
        else {
            return UITableViewCell()
        }
        showCellImage(url: url, user: user, cell: cell)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension GalleryViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if reachedBottom { return }
        
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.contentSize.height
        let distanceFromBottom = scrollViewHeight - contentYOffset
        
        if distanceFromBottom < height {
            reachedBottom = true
            galleryTableView.createBottomSpinnerView()
            appendPhotos()
        }
    }

}
