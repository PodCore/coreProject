//
//  QuadTreeItem.swift
//  OpenLive
//
//  Created by Sky Xu on 3/20/18.
//  Copyright © 2018 Sky.com. All rights reserved.
//

import Foundation

class QuadTreeItem: NSObject, GQTPointQuadTreeItem {
    
    let gqtPoint: GQTPoint
    
    init(point: GQTPoint) {
        self.gqtPoint = point
    }
    
    func point() -> GQTPoint {
        return gqtPoint
    }
}
