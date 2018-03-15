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
//    var vc: HomeViewController!
    var alertVC: CustomAlertView!
    weak var delegate: PassLiveRoomDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        SocketService.instance.observeIfConnected { (payload, ack) in
            SocketService.instance.getChannel {  [unowned self] (success, rooms) in
                if success {
//                    self.delegate?.getLiveRooms(rooms)
                    LiveRoomData.instance.setRoomsToAll(liveRooms: rooms)
                    let locations = LiveRoomData.instance.getRoomData(rooms: rooms)
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
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = sb.instantiateViewController(withIdentifier: "mainTabBarController")
            self.present(tabBarController, animated: true, completion: nil)

        }
        
    }
}
