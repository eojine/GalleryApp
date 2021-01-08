//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryViewController: UIViewController {

    @IBOutlet private weak var galleryTableView: UITableView!
    
    private let defaultHeight: CGFloat = 100.0
    let imageHeight: [CGFloat?] = [200, 300, 400]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: GalleryTableViewCell.identifier,
                            bundle: nil)
        galleryTableView.register(nibName,
                                  forCellReuseIdentifier: GalleryTableViewCell.identifier)
    }
    
}

extension GalleryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
           if let height = imageHeight[indexPath.row] {
               return height
           }else{
               return defaultHeight
           }
       }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return imageHeight.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.identifier,
                                                       for: indexPath) as? GalleryTableViewCell
        else { return UITableViewCell() }
        return cell
    }
    
}

extension GalleryViewController: UITableViewDelegate {
    
}
