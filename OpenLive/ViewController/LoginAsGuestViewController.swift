//
//  LoginAsGuestViewController.swift
//  OpenLive
//
//  Created by Andrew Tsukuda on 2/27/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

protocol PassLiveRoomDelegate: class {
    func getLiveRooms(_ rooms: [Room])
}
class LoginAsGuestViewController: UIViewController {
    var socketSuccess = false
    var loadingIndicator: LoadingIndicatorView!
    var alertVC: CustomAlertView!
    weak var delegate: PassLiveRoomDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let loadingView = Bundle.main.loadNibNamed("LoadingIndicatorView", owner: self, options: nil)![0] as? LoadingIndicatorView else { return }
        self.loadingIndicator = loadingView
        loadingView.configureView(title: "setting up live room", at: view.center)
        
        SocketService.instance.observeIfConnected { (payload, ack) in
            SocketService.instance.getChannel {  [unowned self] (success, rooms) in
                if success {
                    LiveRoomData.instance.setRoomsToAll(liveRooms: rooms)
                    self.socketSuccess = true
                    let locations = LiveRoomData.instance.getRoomData(rooms: rooms)
                    self.loadingIndicator.dismiss()
        
                }
            }
            
        }
    }

    @IBAction func signInAsGuest(_ sender: Any) {
        if self.socketSuccess == false {
            self.view.addSubview(loadingIndicator)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = sb.instantiateViewController(withIdentifier: "mainTabBarController")
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
}
