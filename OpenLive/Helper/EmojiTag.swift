//
//  EmojiTag.swift
//  OpenLive
//
//  Created by Sky Xu on 3/12/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import UIKit

func buttonTag(_ selectedButton: UIButton) -> String {
    switch selectedButton.tag {
    case 0:
        return "smile"
    case 1:
        return "sad"
    default:
        return ""
    }
}
