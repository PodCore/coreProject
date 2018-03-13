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
        guard let loadingView = Bundle.main.loadNibNamed("LoadingIndicatorView", owner: self, options: nil)![0] as? LoadingIndicatorView else { return }
        loadingView.configureView(title: "setting up live room", at: view.center)
        self.view.addSubview(loadingView)
        if self.socketSuccess == true {
            loadingView.dismiss()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
