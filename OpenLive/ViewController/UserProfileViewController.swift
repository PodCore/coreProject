//
//  UserProfileViewController.swift
//  OpenLive
//
//  Created by Tony Cioara on 2/10/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let subscriptionCount = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
//            This cell contains the user's information
            let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell", for: indexPath) as! UserProfileCell
//            cell.profileImageView.image = // Profile image
//            cell.userNameLabel.text = // User name
//            cell.subCountLabel.text = // Number of subscribers
            return cell
        } else {
//            This cell contains a person that the user is following
            let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as! SubscriptionCell
//            cell.streamNameLabel.text = // The name of the current stream or "offline" if there isn't one
//            cell.subImageView.image = // Profile image of person
//            cell.subNameLabel.text = // The username of the person
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
}
