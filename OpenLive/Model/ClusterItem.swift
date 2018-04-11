//
//  ClusterItem.swift
//  OpenLive
//
//  Created by Sky Xu on 3/15/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

class ClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}
