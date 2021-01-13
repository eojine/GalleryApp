//
//  UITableView+.swift
//  GalleryApp
//
//  Created by Eojin Yang on 2021/01/10.
//

import UIKit

extension UITableView {
    
    /// TableView Bottom에 spinnerView생성하는 함수
    func spinnerView(display: Bool) {
        if display {
            self.createBottomSpinnerView()
        } else {
            self.tableFooterView = nil
        }
        self.isScrollEnabled = !display
    }
    
    private func createBottomSpinnerView() {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.frame.size.width,
                                              height: 44))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        self.tableFooterView = footerView
    }
    
}
