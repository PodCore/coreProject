//
//  RegisterViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/23/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
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
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
