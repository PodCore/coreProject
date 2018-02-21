//
//  NewComment.swift
//  OpenLive
//
//  Created by Sky Xu on 2/18/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

struct NewComment: Codable {
    let comment: String
    let commenter: String
    
    init(dict: [String: Any]) {
        comment = dict["comment"] as! String
        commenter = dict["commenter"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["comment": comment as Any,
                "commenter": commenter as Any
        ]
    }
}
