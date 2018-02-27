//
//  OutlinedButton.swift
//  OpenLive
//
//  Created by Andrew Tsukuda on 2/23/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class OutlinedButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
 

}
