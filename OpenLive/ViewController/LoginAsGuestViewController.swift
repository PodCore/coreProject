//
//  LoginAsGuestViewController.swift
//  OpenLive
//
//  Created by Andrew Tsukuda on 2/27/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class LoginAsGuestViewController: UIViewController {
    var socketSuccess = false
    var vc: HomeViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketService.instance.observeIfConnected { (payload, ack) in
            SocketService.instance.getChannel { (success, rooms) in
                if success {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    self.vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
                    self.vc.popularVideos = rooms
                    self.socketSuccess = true
                    
                }
            }
            
        }
    }

    @IBAction func signInAsGuest(_ sender: Any) {
        // present alertVC when load the view
//        let storyboard = UIStoryboard.init(name: "CustomAlertView", bundle: nil)
//        let alertVC = storyboard.instantiateViewController(withIdentifier: "customAlertVC") as! CustomAlertView
//        alertVC.modalPresentationStyle = .overCurrentContext
//        alertVC.modalTransitionStyle = .crossDissolve
//        self.present(alertVC, animated: false, completion: nil)
        
        if self.socketSuccess == true {
            // remove alertVC when connected to socket and got all rooms
//            alertVC.alertLogo.stopAnimating()
//            alertVC.dismiss(animated: true, completion: nil)
//            self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
