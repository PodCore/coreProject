//
//  AlertViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 3/1/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CustomAlertView: UIViewController {

    
    @IBOutlet weak var alertLogo: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
//    override func viewDidLayoutSubviews() {
//        let frame = self.alertLogo.frame
//        print(frame)
//        let padding = CGFloat(15)
//        let loading = NVActivityIndicatorView(frame: frame, type: .pacman, color: UIColor.orange, padding: padding)
//        alertLogo.addSubview(loading)
//    }
    
    func setupView() {
//        let frame = self.alertLogo.frame
//        let padding = CGFloat(15)
//        let loading = NVActivityIndicatorView(frame: frame, type: .pacman, color: UIColor.white, padding: padding)
//        alertLogo.addSubview(loading)
//        loading.startAnimating()
        alertLogo.startAnimating()
    }
}
