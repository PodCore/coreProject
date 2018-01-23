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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
