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
    var loadingIndicator: LoadingIndicatorView!
    var alertVC: CustomAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        guard let loadingView = Bundle.main.loadNibNamed("LoadingIndicatorView", owner: self, options: nil)![0] as? LoadingIndicatorView else { return }
        self.loadingIndicator = loadingView
        loadingView.configureView(title: "setting up live room", at: view.center)
        self.view.addSubview(loadingIndicator)
        
        SocketService.instance.observeIfConnected { (payload, ack) in
            SocketService.instance.getChannel {  [unowned self] (success, rooms) in
                if success {
                    LiveRoomData.instance.setRoomsToAll(liveRooms: rooms)
                    let locations = LiveRoomData.instance.getRoomData(rooms: rooms)
                    self.loadingIndicator.dismiss()
        
                }
            }
            
        }
    }

    @IBAction func signInAsGuest(_ sender: Any) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = sb.instantiateViewController(withIdentifier: "mainTabBarController")
            self.present(tabBarController, animated: true, completion: nil)
    }
}
