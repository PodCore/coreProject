//
//  RegisterViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/23/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google

class RegisterViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let usernametxt = username.text, let emailtxt = email.text, let passwordtxt = password.text,
        !usernametxt.isEmpty, !emailtxt.isEmpty, !passwordtxt.isEmpty else { return }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
//        Where you get the user objject after login
        print(user.profile.email)
    }
    
    func setUpGoogleSignIn() {
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error!)
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let signInButton = GIDSignInButton()
        
//        ADJUST THE POSITION OF THE BUTTON
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGoogleSignIn()
    }
}
