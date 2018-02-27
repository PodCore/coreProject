//
//  User.swift
//  OpenLive
//
//  Created by Tony Cioara on 2/22/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let email: String
    let imageUrl: String
    let followees: [Followee]
    let followers: [String]
    
    init(dict: [String: Any]) {
        username = dict["username"] as! String
        email = dict["email"] as! String
        imageUrl = dict["imageUrl"] as! String
        followees = dict["following"] as! [Followee]
        followers = dict["followers"] as! [String]
    }
    
    func toDict() -> [String: Any] {
        return [
            "username": username as Any,
            "email": email as Any,
            "imageUrl": imageUrl as Any,
            "following": followees as Any,
            "followers": followers as Any
        ]
    }
}
