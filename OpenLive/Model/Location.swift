//
//  Location.swift
//  OpenLive
//
//  Created by Sky Xu on 3/13/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

struct Location {
    let lat: Int
    let long: Int
    
    init(dict: [String: Any]) {
        lat = dict["lat"] as! Int
        long = dict["long"] as! Int
    }
    
    func toDict() -> [String: Any] {
        return ["lat": lat as Any,
                "long": long as Any
        ]
    }
}
