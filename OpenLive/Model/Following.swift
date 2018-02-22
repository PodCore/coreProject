//
//  Following.swift
//  OpenLive
//
//  Created by Sky Xu on 2/10/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

struct Following: Codable {
    let username: String
    let followingName: String
    
    init(dict: [String: AnyObject]) {
        username = dict["username"] as! String
        followingName = dict["followingName"] as! String
    }
    
    func toDict() -> [String: AnyObject] {
        return [
            "username": username as AnyObject,
            "followingName": followingName as AnyObject
        ]
    }
}
