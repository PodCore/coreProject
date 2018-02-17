//
//  OverlayViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 2/16/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import SocketIO

class OverlayViewController: UIViewController {
    
    var comments: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketService.instance.liveComment(comment: "yooooo", owner: "sky1", commenter: "sky2") { (success, data) in
            print(data)
//            self.comments.append(data)
        }
        
        
    }
}
