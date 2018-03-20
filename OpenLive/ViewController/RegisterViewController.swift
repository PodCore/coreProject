//
//  RegisterViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/23/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit

//import RNCryptor

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // notify application notification center about user info if registered!
    func updateUserStatus() {
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let usernameText = usernameTextField.text, let passwordText = passwordTextField.text, let emailText = emailTextField.text, !usernameText.isEmpty, !passwordText.isEmpty, !emailText.isEmpty else { return }
        
//            // Encryption
//            let data = Data()
//            let ciphertext = RNCryptor.encrypt(data: data, withPassword: passwordText)
//            print(ciphertext)
        
        AuthService.instance.registerUser(username: usernameText, email: emailText, password: passwordText) { (username, userId) in
            if username != nil, userId != nil {
                UserdataService.instance.setUserdata1(username: username, avatar: "avatar")
                
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "mainTabBar") 
                self.navigationController?.pushViewController(tabBarVC, animated: true)
            } else {
                print("sign up failed")
            }
        }
    }
    
}


