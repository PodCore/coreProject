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
        
//        Where you get the user object after login
        print(user.profile.email)
        AuthService.instance.registerUser(username: user.profile.name, email: user.profile.email, password: "LoggedInWithGoogle") { (username, userId ) in
//            if username != nil, userId != nil {
//                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//                let hostVC = storyBoard.instantiateViewController(withIdentifier: "hostVC") as! HostViewController
//                self.present(hostVC, animated: true, completion: nil)
//            } else {
//                print("sign up failed")
//            }
        }
//        registerUser(username: user.profile.name, email: user.profile.email, password: "GoogleSignUp", completion: @escaping CompletionHandler)
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
