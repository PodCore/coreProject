//
//  RegisterViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/23/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
// TODO: Delete login stuff after connecting SB to LoginVC
// TODO: Add popup view when same username


import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Google

class RegisterViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {
    
    var loginName: String?
    var loginEmail: String?
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var regularButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGoogleSignIn()
        
    }
    
    // Notify application notification center about user info if registered!
    func updateUserStatus() {
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    
    //   MARK: (helper) main func to call google Signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        AuthService.instance.registerUser(username: user.profile.givenName, email: user.profile.email, password: "gmailpassword ", completion: { (username, userId) in
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "mainTabBarController") as! CreateRoomViewController

            self.navigationController?.pushViewController(mainVC, animated: true)
        })
    }
    
    //    MARK: (helper) setupGoogleSignin
    func setUpGoogleSignIn() {
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil {
            print(error!)
            return
        }
        //  call Gmail uiDelegate and signindelegate
        DispatchQueue.main.async {
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().delegate = self
        }
    }
    
    //  MARK : (helper) fbloginmanager to authenticate user via fb
    
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
    
    //  MARK: (helper) fbgraghQL request get user public profile and email info
    
    func fbGraphRequest(completion: @escaping (Bool) -> ()) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, first_name, email"])
        request?.start(completionHandler: { (connection, result, error) in
            guard let userInfo = result as? [String: Any] else { return }
            self.loginName = userInfo["first_name"]! as? String
            self.loginEmail = userInfo["email"]! as? String
            completion(true)
        })
    }
    
    //    MARK: IBAction: GmailLoginButton
    
    @IBAction func signUpWithGmailButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //    MARK: IBAction: RegularSignupButton
    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let usernametxt = usernameTextField.text, let emailtxt = emailTextField.text, let passwordtxt = passwordTextField.text,
                !usernametxt.isEmpty, !emailtxt.isEmpty, !passwordtxt.isEmpty else { return }
        
        AuthService.instance.registerUser(username: "bob", email: "bob@mail.com", password: "passwordtxt") { (username, userId) in  //username and userID from authservice
            if username != nil, userId != nil {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "mainTabBarController")
                self.navigationController?.pushViewController(mainVC, animated: true)
            } else {
                // MARK: Handled in Authservice-- should it be in here instead? Ask Sky or E
                print("sign up failed")
            }
        }
    }
    
    //    MARK: IBAction: fbLoginButton
    @IBAction func fbLoginTapped(_ sender: UIButton) {
        fbManagerSuccess{ (success) in
            if success {
                AuthService.instance.registerUser(username: self.loginName!, email: self.loginEmail!, password: "facebookpassword ", completion: { (username, userId) in
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let mainVC = storyBoard.instantiateViewController(withIdentifier: "mainTabBarController")
                    self.navigationController?.pushViewController(mainVC, animated: true)
                })
            }
        }
    }
    
}

