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
    var alertVC: CustomAlertView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let storyboard = UIStoryboard.init(name: "CustomAlertView", bundle: nil)
//        alertVC = storyboard.instantiateViewController(withIdentifier: "customAlertVC") as! CustomAlertView
//        alertVC.modalPresentationStyle = .overCurrentContext
//        alertVC.modalTransitionStyle = .crossDissolve
        
        SocketService.instance.observeIfConnected { (payload, ack) in
            SocketService.instance.getChannel {  [unowned self] (success, rooms) in
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
        if self.socketSuccess == true {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
