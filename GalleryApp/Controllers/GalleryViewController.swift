//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var galleryTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    private var photos: [Photo] = []
    private var currentIndexPath: IndexPath?
    private var pageNumber = 1
    private var isSearching = false
    private var fetchingMore = false
    private var displayAlert = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        appendPhotos()
    }
    
    // MARK: - Methods
    
    private func registerXib() {
        let cellNibName = UINib(nibName: GalleryTableViewCell.identifier,
                                bundle: nil)
        galleryTableView.register(cellNibName,
                                  forCellReuseIdentifier: GalleryTableViewCell.identifier)
    }
    
}

// MARK: DataLoadable

extension GalleryViewController: DataLoadable {
    
    private func appendPhotos() {
        guard !fetchingMore else { return }
        fetchingMore = true
        galleryTableView.spinnerView(display: true)
        
        loadPhotosFromServer(pageNumber: pageNumber,
                             search: isSearching ? searchBar.text : nil) { [weak self] result in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self?.displayPhotos(photos)
                    self?.galleryTableView.spinnerView(display: false)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.galleryTableView.isScrollEnabled = true
                    self?.fetchingMore = false
                    self?.galleryTableView.spinnerView(display: false)
                }
                self?.showErrorAlert(error: error)
            }
        }
    }
    
    /// 받아온 photos 뿌려주고, pageNumber올리는 함수
    private func displayPhotos(_ photos: [Photo]) {
        self.photos.append(contentsOf: photos)
        galleryTableView.reloadData()
        fetchingMore = false
        pageNumber += 1
    }

    /// Alert 띄우는 함수
    private func showErrorAlert(error: NetworkError) {
        if displayAlert { return }
        displayAlert = true
        DispatchQueue.main.async { [weak self] in
            self?.showSimpleAlert(title: "Error!",
                                  message: error.errorToString()) {
                self?.displayAlert = false
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
        else { return 0 }
        let cellHeight = CGFloat(height)
        // 계산된 셀 높이 테이블 뷰 셀 높이로 지정
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
                   didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?
                .instantiateViewController(withIdentifier: DetailViewController.identifier)
                as? DetailViewController
        else { return }
        
        // detailViewController에 필요한 data 주입
        detailViewController.searchText = isSearching ? searchBar.text : nil
        detailViewController.photos = photos
        detailViewController.pageNumber = pageNumber
        detailViewController.currentIndexPath = indexPath
        detailViewController.delegate = self
        detailViewController.modalPresentationStyle = .fullScreen
        
        present(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let cell = cell as? GalleryTableViewCell,
              let user = photos[indexPath.row].user?.name,
              let url = photos[indexPath.row].urls?.raw
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
        
        if isBottom(indexPath, photos) {
            appendPhotos()
        }
    }
    
    private func isBottom(_ indexPath: IndexPath,
                          _ photos: [Photo])  -> Bool {
        return indexPath.row + 1 == photos.count
    }
    
}

extension GalleryViewController: UISearchBarDelegate {
    
    /// 취소 버튼이 클릭됐을때 함수
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        displaySearchPhotos()
    }
    
    /// Search 버튼이 클릭됐을때 함수
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = true
        displaySearchPhotos()
    }
    
    /// Search하기 전에 tableview 비우고, appendPhotos()하는 함수
    private func displaySearchPhotos() {
        photos.removeAll()
        pageNumber = 1
        galleryTableView.reloadData()
        appendPhotos()
        searchBar.resignFirstResponder()
    }
    
}

extension GalleryViewController: SendDataDelegate {
    
    /// DetailViewController에서 바뀐 데이터를 받아와서 GalleryViewController에 넣는 함수
    func send(photos: [Photo], pageNumber: Int) {
        self.photos = photos
        self.pageNumber = pageNumber
        galleryTableView.reloadData()
    }
    
    /// DetailViewController의 indexPath 를 GalleryViewController에 넣고, Scroll하는 함수
    func scrollToIndexPath(at: IndexPath) {
        currentIndexPath = at
        galleryTableView.scrollToRow(at: at,
                                     at: .middle,
                                     animated: false)
    }
    
}
