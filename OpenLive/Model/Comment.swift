//
//  Comment.swift
//  OpenLive
//
//  Created by Sky Xu on 2/16/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

struct Comment: Codable {
    
    let comment: String
    let owner: String
    let commenter: String
    
    init(dict: [String: Any]) {
        comment = dict["comment"] as! String
        owner = dict["owner"] as! String
        commenter = dict["commenter"] as! String
    }
    
    func toDict() -> [String: Any] {
        return [ "comment": comment as Any,
                 "owner": owner as Any,
                 "commenter": commenter as Any
        ]
    }
}
