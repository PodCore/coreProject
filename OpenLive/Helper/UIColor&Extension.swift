//
//  UIColor&Extension.swift
//  OpenLive
//
//  Created by Sky Xu on 3/20/18.
//  Copyright © 2018 Sky.com. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "invalid red color")
        assert(green >= 0 && green <= 255, "invalid green color")
        assert(blue >= 0 && blue <= 255, "invalid blue color")
        self.init(red: red / 255, green: green / 255, blue: blue / 255, a: a)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff)
    }
}
