//
//  OverlayViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 2/16/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import SocketIO

class OverlayViewController: UIViewController {
    
    @IBOutlet weak var commentInputContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var roomId: String?
    var comments: [String] = []
    var commenter: String?
    var commentData = [NewComment]()
    let tableViewDatasource = TableViewDataSource(items: [])
    
    @IBAction func commentTapped(_ sender: UIButton) {
        SocketService.instance.liveComment(comment: "yooooo", owner: "sky1", commenter: "sky2", roomId: roomId!) { (success) in
            if success {
                print("successfully commented")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDatasource.items = comments
        DispatchQueue.main.async {
            self.tableView.dataSource = self.tableViewDatasource
        }
        
        //  wait 1 s for socket to work and automtically roll comments
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick(_:)), userInfo: nil, repeats: true)
        
        SocketService.instance.getComments { (success, data) in
            print(data)
            self.comments.append(data.comment)
//            self.tableView.reloadData()
        }
        
        tableViewDatasource.configureCell = {(tableView, indexPath) -> UITableViewCell in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentCell
            if self.comments.count > 0 {
                cell.comment.text = self.comments[indexPath.row]
            }
            return cell
        }
    }
    
//    for automatically scrolling tableView of comments
    @objc func tick(_ time: Timer) {
        guard comments.count > 0 else { return }
        if tableView.contentSize.height > tableView.bounds.height {
            tableView.contentInset.top = 0
        }
        tableView.scrollToRow(at: IndexPath(row: comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
    }
}
