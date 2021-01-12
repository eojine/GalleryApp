//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    @IBOutlet private weak var galleryTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var reachedBottom = false
    private var fetchingMore = false
    private var pageNumber = 1
    private var photos: [Photo] = []
    private var currentIndexPath: IndexPath?
    private var isSearching = false
    
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
    
    private func appendPhotos(searchText: String? = nil) {
        fetchingMore = true
        spinnerView(display: true)
        loadPhotosFromServer(pageNumber: pageNumber,
                             search: searchText) { [weak self] photos in
            guard let self = self else { return }
            guard let resultPhotos = photos else {
                DispatchQueue.main.async {
                    self.galleryTableView.isScrollEnabled = true
                    self.spinnerView(display: false)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.photos.append(contentsOf: resultPhotos)
                self.galleryTableView.reloadData()
                self.fetchingMore = false
                self.pageNumber += 1
                self.spinnerView(display: false)
            }
        }
    }
    
    private func spinnerView(display: Bool) {
        if display {
            galleryTableView.createBottomSpinnerView()
        } else {
            galleryTableView.tableFooterView = nil
        }
        galleryTableView.isScrollEnabled = !display
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
        if isSearching {
            detailViewController.search = searchBar.text
        }
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
        let offsetY = scrollView.contentOffset.y
        let contentHeight = galleryTableView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !reachedBottom {
                reachedBottom = true
                if !fetchingMore {
                    print("여기?????")
                    if isSearching {
                        appendPhotos(searchText: searchBar.text)
                    } else {
                        appendPhotos()
                    }
                    
                }
            } else {
                reachedBottom = false
            }
        }
    }
    
}

extension GalleryViewController: SendDataDelegate {
    
    func send(photos: [Photo], pageNumber: Int) {
        self.photos = photos
        self.pageNumber = pageNumber
        galleryTableView.reloadData()
    }
    
    func scrollToIndexPath(at: IndexPath) {
        currentIndexPath = at
        reachedBottom = true
        galleryTableView.scrollToRow(at: at,
                                     at: .middle,
                                     animated: false)
    }
    
}

extension GalleryViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        photos.removeAll()
        pageNumber = 1
        galleryTableView.reloadData()
        appendPhotos()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        photos.removeAll()
        pageNumber = 1
        galleryTableView.reloadData()
        appendPhotos(searchText: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
}
