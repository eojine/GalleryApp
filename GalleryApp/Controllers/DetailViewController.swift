//
//  DetailViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/11.
//

import UIKit

final class DetailViewController: UIViewController {
    
    static let identifier = String(describing: DetailViewController.self)
    
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    
    var photos: [Photo] = []
    var currentIndexPath: IndexPath = [0, 0]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailCollectionView.scrollToItem(at: currentIndexPath,
                                          at: .right,
                                          animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    private func registerXib() {
        let cellNibName = UINib(nibName: DetailCollectionViewCell.identifier,
                                bundle: nil)
        detailCollectionView.register(cellNibName,
                                      forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
    }
    
    @IBAction private func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true) {
            print("딜리게이트 쏘기")
        }
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier,
                                     for: indexPath) as? DetailCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(title: "\(indexPath.item) \(photos[indexPath.item].user!)")
        return cell
    }
    
}

extension DetailViewController: UICollectionViewDelegate {
    
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
