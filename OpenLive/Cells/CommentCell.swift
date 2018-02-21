//
//  CommentTableViewCell.swift
//  OpenLive
//
//  Created by Sky Xu on 2/19/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var commentContainer: UIView!
    @IBOutlet weak var comment: UILabel!
//    var selfComment: String? {
//        didSet {
//            updateUI()
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentContainer.layer.cornerRadius = 3
    }
//
//    func updateUI() {
//        comment.text = selfComment!
//    }

}
