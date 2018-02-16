//
//  SocketService.swift
//  OpenLive
//
//  Created by Sky Xu on 2/8/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import SocketIO
import UIKit

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(
        socketURL: URL(string: Config.serverUrl)!,
        config: [.log(true), .compress, .reconnects(true)]
    )
    
//    only initialize socket when we call this service instance so we can fix manager property not initalized before runtime issue
   lazy var socket: SocketIOClient = manager.defaultSocket
    
    func establishConnection() {
        socket.connect()
    }
    
    func observeIfConnected(completion: @escaping NormalCallback){
        socket.on(clientEvent: .disconnect, callback: completion)
        socket.on(clientEvent: .connect, callback: completion)
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(id: String, name: String, owner: String, topic: String, viewCount: Int, likes: Int, viewers: [String], completion: @escaping (Bool) -> ()) {
        let room = Room(dict: ["name": name as Any,
                               "id": id as Any,
                               "owner": owner as Any,
                               "topic": topic as Any,
                               "viewCount": viewCount as Any,
                               "viewers": viewers as [String]])
        guard let data = try? JSONEncoder().encode(room) else {return}
        socket.emit("create_room", data)
        
    }
    
    func joinChannel(username: String, owner: String, completion: @escaping (Bool) -> ()) {
        let data = ["username": username, "owner": owner]
        socket.emit("create_room", data)
    }
    // MARK: get data from service once socket connected
    func getChannel(completion: @escaping (Bool, [Room]) -> ()) {
//        listening for event
            self.socket.emit("get_rooms")
            socket.on("get_rooms") {(data, ack) in
                guard let json = data[0] as? [Any]
                   else {return}
                let rooms = json.map{Room(dict:$0 as! [String : Any])}
                
        completion(true, rooms)
        }
    }
    
    // MARK:  Follow Host
    func followHost(owner: String, completion: @escaping (Bool) -> ()) {
        let following = Following(dict: ["username": "sky" as AnyObject, "followingName": "james" as AnyObject])
        
        self.socket.emit("new_follower", following.toDict())
        completion(true)
        
    }
    
}
