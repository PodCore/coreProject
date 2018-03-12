//
//  Emoji.swift
//  OpenLive
//
//  Created by Sky Xu on 3/11/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

struct Emoji {
    let emojier: String
    let emojiNum: String
    let emojiGram: Any
    
    init(dict: [String: Any]) {
        emojier = dict["emojier"] as! String
        emojiNum = dict["emojiNum"] as! String
        emojiGram = dict["emojiGram"] as! Any
    }
    
    func toDict() -> [String: Any] {
        return [ "emojier": emojier as Any,
                 "emojiNum": emojiNum as Any,
                 "emojiGram": emojiGram as Any
        ]
    }
}

