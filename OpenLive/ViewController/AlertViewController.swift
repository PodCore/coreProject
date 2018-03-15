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
  
    func setupView() {
        alertLogo.startAnimating()
    }
}
