//
//  Room.swift
//  OpenLive
//
//  Created by Sky Xu on 2/8/18.
//  Copyright © 2018 Agora. All rights reserved.
import Foundation

struct Rooms: Codable {
    let rooms: [Room]
}

struct Room: Codable {
    let name: String
    let id: String
    let owner: String
    let topic: String
    let viewCount: Int
    let likes: Int
    let viewers: [String]
    let image: String

    init(dict: [String: Any]) {
        name = dict["name"] as! String
        id = dict["id"] as! String
        owner = dict["owner"] as! String
        topic = dict["topic"] as! String
        viewCount = dict["viewCount"] as! Int
        likes = dict["likes"] as! Int
        viewers = dict["viewers"] as! [String]
        image = dict["image"] as! String
    }

    func toDict() -> [String: Any] {
        return [
            "name": name as Any,
            "id": id as Any,
            "owner": owner as Any,
            "topic": topic as Any,
            "viewCount": viewCount as Any,
            "likes": likes as Any,
            "viewers": viewers as [String],
            "image": image as String
        ]
    }
}

