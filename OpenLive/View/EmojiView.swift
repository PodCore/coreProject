//
//  EmojiView.swift
//  OpenLive
//
//  Created by Sky Xu on 3/12/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class EmojiView: UIView {
    
  @IBAction func tapped(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            let overLayVC = OverlayViewController()
            overLayVC.xConstrint.constant = -400
        }
    }
}
