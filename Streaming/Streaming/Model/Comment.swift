//
//  Comment.swift
//  Streaming
//
//  Created by Sky Xu on 1/22/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var text: String
    init(dict: [String: AnyObject]) {
        text = dict["text"] as! String
    }
}
