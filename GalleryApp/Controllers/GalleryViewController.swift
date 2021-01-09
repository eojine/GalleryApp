//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    @IBOutlet private weak var galleryTableView: UITableView!
    
    private var isPaging = false // 현재 페이징중인지 체크
    private var hasNextPage = false // 다음 페이지를 가지는지 체크
    private var pageNumber = 1
    private let defaultHeight: CGFloat = 44.0 // LoadingCell 높이
    private let defaultCellCount = 0
    private let loadingCellCount = 1
    private var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryTableView.separatorStyle = .none
        registerXib()
        loadPhotos()
    }
    
    private func registerXib() {
        let cellNibName = UINib(nibName: GalleryTableViewCell.identifier,
                                bundle: nil)
        let loadingNibName = UINib(nibName: LoadingTableViewCell.identifier,
                                   bundle: nil)
        
        galleryTableView.register(cellNibName,
                                  forCellReuseIdentifier: GalleryTableViewCell.identifier)
        galleryTableView.register(loadingNibName,
                                  forCellReuseIdentifier: LoadingTableViewCell.identifier)
    }
    
    private func loadPhotos() {
        PhotoService.shared.get(page: pageNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.galleryTableView.reloadData()
                    self.pageNumber += 1
                }
            case .failure(let error):
                switch error {
                case .invalidURL:
                    break
                case .invalidResponse:
                    break
                case .invalidData:
                    break
                case .failedRequest:
                    break
                case .failedParsing:
                    break
                }
            }
        }
    }
    
}

extension GalleryViewController: UITableViewDataSource {
    
    enum Section: Int, CaseIterable {
        case data // section1: 데이터 표시
        case loading // section2: 로딩셀 표시
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isPaging { return defaultHeight }
        let deviceWidth = Float(UIScreen.main.bounds.size.width)
        guard let height = photos[indexPath.row]
                .photoHeightForDevice(deviceWidth) else { return defaultHeight }
        let cellHeight = CGFloat(height)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)
        switch section {
        case .data:
            return photos.count
        case .loading where isPaging && hasNextPage:
            return loadingCellCount
        default:
            return defaultCellCount
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        let section = Section(rawValue: indexPath.section)
        switch section {
        case .data:
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: GalleryTableViewCell.identifier,
                                         for: indexPath) as? GalleryTableViewCell,
                  let user = photos[indexPath.row].user?.name,
                  let url = photos[indexPath.row].urls?.small
            else { return defaultCell }
            
            cell.activityStart()
            ImageCacheService.shared.load(url: url) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.configure(user: user, photo: image)
                        cell.activityStop()
                    }
                case .failure(let error):
                    print("request fail \(error.localizedDescription)")
                }
                
            }
            
            return cell
        case .loading:
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier,
                                         for: indexPath) as? LoadingTableViewCell
            else { return defaultCell }
            cell.start()
            return cell
        default:
            return defaultCell
        }
    }
    
}

extension GalleryViewController: UITableViewDelegate {
    
}
