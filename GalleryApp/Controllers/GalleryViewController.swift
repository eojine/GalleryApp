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
    private let defaultHeight: CGFloat = 44.0
    private let defaultCellCount = 0
    private let loadingCellCount = 1
    private var photos: [Photo] = []
    
    let imageHeight: [CGFloat?] = [200, 300, 400]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        PhotoService.shared.getAll { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos
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
        if let height = imageHeight[indexPath.row], !isPaging {
            return height
        }
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)
        switch section {
        case .data:
            return imageHeight.count
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
                                         for: indexPath) as? GalleryTableViewCell
            else { return defaultCell }
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
