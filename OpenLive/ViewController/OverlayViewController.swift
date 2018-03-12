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
    var comments: [String] = [] {
        didSet {
            self.tableViewDatasource.items = comments
            self.tableView.dataSource = self.tableViewDatasource
            self.tableView.reloadData()
        }
    }// call didset so that we can update datasource to tableview when it's changed?
    var commenter: String?
    var commentData = [NewComment]()
    let tableViewDatasource = TableViewDataSource(items: [])
    
    @IBAction func commentTapped(_ sender: UIButton) {
//        self.comments.insert(textField.text!, at: 0)
//        self.comments.append(textField.text!)
        
//         self.tableView.reloadData()
        SocketService.instance.liveComment(comment: textField.text!, owner: "sky", commenter: "sky2", roomId: roomId!) { (success) in
            if success {
                print("successfully commented")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset.top = tableView.bounds.height
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDatasource.items = comments
        self.tableView.dataSource = self.tableViewDatasource
        
        //  wait 1 s for socket to work and automtically roll comments
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick(_:)), userInfo: nil, repeats: true)
        
        SocketService.instance.getComments { (success, data) in
            print(data)
            self.comments.append(data.comment)
            self.tableView.reloadData()
        }
        
        tableViewDatasource.configureCell = {(tableView, indexPath) -> UITableViewCell in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CommentCell
            if self.comments.count > 0 {
                cell.selfComment = self.comments[indexPath.row]
            }
            return cell
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        
        textField.resignFirstResponder()
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
