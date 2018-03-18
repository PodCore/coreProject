//
//  OverlayViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 2/16/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import SocketIO
import IHKeyboardAvoiding
 
class OverlayViewController: UIViewController {
    
    @IBOutlet weak var commentInputContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upvoteButton: DesignableButton!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var emojiCount: UILabel!
    @IBOutlet weak var emojiButton: DesignableButton!
    @IBOutlet weak var waveView: WaveEmitterView!
    @IBOutlet weak var emojiStackView: UIStackView!
    @IBOutlet weak var xConstrint: NSLayoutConstraint!
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    
    var clientRole: Int!
    let emojiNum = 5
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
        if self.clientRole == 1 {
            commentInputContainer.isHidden = true
            textField.isHidden = true
            self.emojiStackView.isHidden = true
            self.emojiButton.isHidden = true
            self.upvoteButton.isHidden = true
            self.sendButton.isHidden = true
        }
        self.tableViewDatasource.items = comments
        self.tableView.dataSource = self.tableViewDatasource
        
        //  wait 1 s for socket to work and automtically roll comments
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick(_:)), userInfo: nil, repeats: true)
        
//        hide keyboard when type
        KeyboardAvoiding.avoidingView = self.commentInputContainer
        
        SocketService.instance.getComments { (success, data) in
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
        
        SocketService.instance.getUpvote { (success, likes) in
            if success {
                let heart = UIImage(named: "heart")
                self.waveView.emitImage(heart!)
                self.likes.text = "\(likes.likes)"
                
            }
        }
        
        SocketService.instance.getEmoji { (success, emojier, emojiCount, emojiNum)  in
            if success {
//                self.emojiCount.text = "\(emojiCount)"
                let emoji = UIImage(named: ("emoji-" + emojiNum ))!
                self.waveView.emitImage(emoji)
            }
        }
    }
    
    // MARK:   IBOutlets
    @IBAction func emojiTapped(_ sender: DesignableButton) {
        self.xConstrint.constant = 0
    }
    
    @IBAction func upvoteTapped(_ sender: DesignableButton) {
        SocketService.instance.sendUpvote(owner: "sky", upvoter: "tony") { (success) in
            if success {
                print("upvote success")
            }
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

extension OverlayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SocketService.instance.sendEmoji(emojier: "tony", emojiNum: "\(indexPath.row)", owner: "sky") { (success) in
            if success {
                print("emoji sent success")
            }
        }
    }
}

extension OverlayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return emojiNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emojiCell = UINib(nibName: "EmojiCollectionViewCell", bundle: Bundle.main)
        emojiCollectionView.register(emojiCell, forCellWithReuseIdentifier: "cell")
        let cell = self.emojiCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmojiCollectionViewCell
        let btnImg = UIImage(named: "emoji-\(indexPath.row)")
        cell.emoButton.setImage(btnImg, for: .normal)

        return cell
    }
    
    
}
