//
//  Followee.swift
//  OpenLive
//
//  Created by Tony Cioara on 2/21/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import Foundation

struct Followee: Codable {
    let username: String
    let streamName: String
    let profilePic: String
    let streamId: String
    
    init(dict: [String: Any]) {
        self.username = dict["username"] as! String
        self.streamName = dict["streamName"] as! String
        self.profilePic = dict["imageURL"] as! String
        self.streamId = dict["streamId"] as! String
    }
}
