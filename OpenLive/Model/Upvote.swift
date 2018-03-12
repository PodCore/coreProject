//
//  Upvote.swift
//  OpenLive
//
//  Created by Sky Xu on 3/12/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

struct Upvote {
    let likes: Int
    
    init(dict: [String: Any]) {
        likes = dict["likes"] as! Int
    }
}
