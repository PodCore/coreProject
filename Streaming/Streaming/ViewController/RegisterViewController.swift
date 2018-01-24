//
//  RegisterViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/23/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit

class RegisterViewController: UIViewController {
    
    var loginName: String?
    var loginEmail: String?
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //  MARK : fbloginmanager to authenticate user via fb
    
    func fbManagerSuccess(completion: @escaping (Bool) -> ()) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) {
            (result, error) in
            if let error = error {
                print("faied to login fb, \(error)")
                
                return
            }
            
            guard (FBSDKAccessToken.current()) != nil else {
                print("failed to get accesstoken")
                
                return
            }
            self.fbGraphRequest { (success) in
                if success {
                    completion(true)
                }
            }
        }
    }
    
    //  MARK: fbgraghQL request get user public profile and email info
    
    func fbGraphRequest(completion: @escaping (Bool) -> ()) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, first_name, email"])
        request?.start(completionHandler: { (connection, result, error) in
            guard let userInfo = result as? [String: Any] else { return }
            self.loginName = userInfo["first_name"]! as? String
            self.loginEmail = userInfo["email"]! as? String
           completion(true)
        })
    }

    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let usernametxt = username.text, let emailtxt = email.text, let passwordtxt = password.text,
        !usernametxt.isEmpty, !emailtxt.isEmpty, !passwordtxt.isEmpty else { return }
        
        AuthService.instance.registerUser(username: usernametxt, email: emailtxt, password: passwordtxt) { (username, userId) in
            if username != nil, userId != nil {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let hostVC = storyBoard.instantiateViewController(withIdentifier: "hostVC") as! HostViewController
                self.present(hostVC, animated: true, completion: nil)
            } else {
                print("sign up failed")
            }
        }
    }
    
    @IBAction func fbLoginTapped(_ sender: UIButton) {
        fbManagerSuccess{ (success) in
            if success {
                AuthService.instance.registerUser(username: self.loginName!, email: self.loginEmail!, password: "facebookpassword ", completion: { (username, userId) in
                    print(username, userId)
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let hostVC = storyBoard.instantiateViewController(withIdentifier: "hostVC") as! HostViewController
                    self.present(hostVC, animated: true, completion: nil)
                })
            }
        }
    }
}

