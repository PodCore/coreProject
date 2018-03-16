//
//  LoadingIndicatorView.swift
//  OpenLive
//
//  Created by Sky Xu on 3/12/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LoadingIndicatorView: UIView {
    
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var title: UILabel!
    
    func configureView(title: String, at location: CGPoint) {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.backgroundColor = UIColor(red:0.95, green:0.47, blue:0.10, alpha:1.0)
        self.center = location
        self.title.text = title
        self.indicatorView.type = .ballClipRotateMultiple
        self.indicatorView!.startAnimating()
    }
    
    func dismiss() {
        self.removeFromSuperview()
        indicatorView?.stopAnimating()
    }
    
    deinit {
        print("Yo we done init indicatorView")
    }
    
}
