//
//  PassAlertViewController.swift
//  OpenLive
//
//  Created by Andrew Tsukuda on 4/3/18.
//  Copyright © 2018 Sky.com. All rights reserved.
//

import UIKit

class PassAlertViewController: UIViewController {
    
    lazy var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showAlertView(title: String, message: String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }

}
