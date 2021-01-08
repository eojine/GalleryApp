//
//  GalleryViewController.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/08.
//

import UIKit

final class GalleryViewController: UIViewController {

    @IBOutlet private weak var galleryTableView: UITableView!
    
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

