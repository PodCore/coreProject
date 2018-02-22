//
//  UserProfileViewController.swift
//  OpenLive
//
//  Created by Tony Cioara on 2/10/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let subscriptionCount = 0
    var username = "__guest__"
    var user: User?
    let customImageView = CustomImageView()
    let imageArray = [UIImage]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
//            This cell contains the user's information
            let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell", for: indexPath) as! UserProfileCell
            guard let user = self.user else {return cell}
//            cell.profileImageView.image = // Profile image
            cell.userNameLabel.text = self.username
            cell.subCountLabel.text = String(user.followers.count)
            return cell
        } else {
//            This cell contains a person that the user is following
            let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as! SubscriptionCell
            guard let user = self.user else {return cell}
            cell.streamNameLabel.text = user.followees[indexPath.row - 1].streamName
            cell.subImageView.image = self.imageArray[indexPath.row - 1]
            cell.subNameLabel.text = user.followees[indexPath.row - 1].username
            return cell
        }
    }
    
    func getUser(username: String) {
        if username == "__guest__" { return }
        SocketService.instance.getUser(username: username) { (success, user) in
            self.user = user
            self.tableView.reloadData()
        }
        self.loadUserImage()
        self.loadFolloweeImages()
    }
    
    func loadFolloweeImages() {
        guard let user = self.user else {return}
        for followee in user.followees {
            customImageView.loadImageFromUrlString(urlString: followee.profilePic)
        }
        self.tableView.reloadData()
    }
    
    func loadUserImage() {
        guard let user = self.user else {return}
            customImageView.loadImageFromUrlString(urlString: user.imageUrl)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: "username") {
            self.username = username
        }
        
        self.getUser(username: username)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
