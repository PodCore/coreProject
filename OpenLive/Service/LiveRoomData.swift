//
//  LiveRoomData.swift
//  OpenLive
//
//  Created by Sky Xu on 3/14/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import MapKit

//for convert Location model to arr of CLLocation 
class LiveRoomData {
    static let instance = LiveRoomData()
   
    public private(set) var locations = [CLLocationCoordinate2D]()
    public private(set) var rooms = [Room]()
    
    func getRoomData(rooms: [Room]) -> [CLLocationCoordinate2D] {
       let cleanerLocation =  rooms.map { $0.location as! [String: Int]}
        for room in cleanerLocation {
            let lat = room["lat"]
            let long = room["long"]
            let location = CLLocationCoordinate2D(latitude: Double(lat!), longitude: Double(long!))
            locations.append(location)
        }
       return locations
    }
    
    func setRoomsToAll(liveRooms: [Room]) {
        rooms = liveRooms
        print(rooms)
    }
}
