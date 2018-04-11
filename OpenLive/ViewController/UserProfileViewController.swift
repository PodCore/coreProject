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
    @IBOutlet weak var guestView: UIView!
    @IBOutlet weak var tableView: UITableView!
    //    TODO: Add loading icon to images. Reload tableview when images are loaded
    let subscriptionCount = 0
    var username = "__guest__" {
        didSet {
            if username != "__guest__" {
                 guestView.isHidden = true
            }
        }
    }
    var user: User?
    
    @IBAction func signUpButton(_ sender: Any) {
        print("YES")
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        print("YESYES")
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 143.5
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = self.user else {return 0}
        return user.followees.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
//            This cell contains the user's information
            let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell", for: indexPath) as! UserProfileCell
            guard let user = self.user else {return cell}
            cell.profileImageView.loadImageFromUrlString(urlString: user.imageUrl)
            cell.userNameLabel.text = self.user?.username
            cell.subCountLabel.text = String("Followers: \(user.followers.count)")
            return cell
        } else {
//            This cell contains a person that the user is following
            let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as! SubscriptionCell
            guard let user = self.user else {return cell}
            cell.streamNameLabel.text = user.followees[indexPath.row - 1].streamName
            cell.subImageView.loadImageFromUrlString(urlString: user.followees[indexPath.row - 1].profilePic)
            cell.subNameLabel.text = user.followees[indexPath.row - 1].username
            return cell
        }
    }
    
    func getUser(username: String) {
        if username == "__guest__" { return }
        SocketService.instance.getUser(username: username) { (success, user) in
            if success {
                self.user = user
                self.tableView.reloadData()
            }
        }
    }
    
//    func loadFolloweeImages(completion: @escaping ()->()) {
//        guard let user = self.user else {return}
//        for followee in user.followees {
//            customImageView.loadImageFromUrlString(urlString: followee.profilePic){
//                self.imageArray.append(self.customImageView.image!)
//                if self.imageArray.count == user.followees.count {
//                    completion()
//                }
//            }
//        }
//
//    }
//
//    func loadUserImage(completion: @escaping ()->()) {
//        guard let user = self.user else {return}
//        self.customImageView.loadImageFromUrlString(urlString: user.imageUrl) {
//            self.userImage = self.customImageView.image
//            if self.userImage != nil {
//                completion()
//            }
//        }
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let username = defaults.string(forKey: "username") {
            self.username = username
        }
        self.getUser(username: username)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guestView.isHidden = false
        tableView.isHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
