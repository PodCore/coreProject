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
import GoogleSignIn
import Google
import RNCryptor

class RegisterViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {
    
    var loginName: String?
    var loginEmail: String?
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var regularButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGoogleSignIn()
        
    }
    
    //    notifi application notification center about user info if registered!
    func updateUserStatus() {
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    //    MARK: put these into view did load of profile VC
//     NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
//
//    @objc func userDataDidChange(_ notif: Notification) {
//        if AuthService.instance.isLoggedIn {
////            update userinfo if user is logged in
//            let username = UserdataService.instance.username
//            let avatar = UserdataService.instance.avatar
//        } else {
////            set UI to be default value
//        }
//    }
    
    
    //   MARK: (helper) main func to call google Signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        AuthService.instance.registerUser(username: user.profile.givenName, email: user.profile.email, password: "gmailpassword ", completion: {[unowned self] (username, userId) in
//            print(username, userId)
            let storyBoard = UIStoryboard.init(name: "CreateRoom", bundle: nil)
            let createRoomVC = storyBoard.instantiateViewController(withIdentifier: "createRoomVC") as! CreateRoomViewController
//            let storyBoard = UIStoryboard.init(name: "LiveRoom", bundle: nil)
//            let createRoomVC = storyBoard.instantiateViewController(withIdentifier: "liveRoomVC") as! LiveRoomViewController
            UserdataService.instance.setUserdata1(username: username, avatar: "avatar")
            self.navigationController?.pushViewController(createRoomVC, animated: true)
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
        DispatchQueue.main.async { [weak self] in
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
        request?.start(completionHandler: { [unowned self] (connection, result, error) in
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
//        guard let usernametxt = username.text, let emailtxt = email.text, let passwordtxt = password.text,
//        !usernametxt.isEmpty, !emailtxt.isEmpty, !passwordtxt.isEmpty else { return }
        
//        // Encryption
//        let data = Data()
//        let ciphertext = RNCryptor.encrypt(data: data, withPassword: passwordtxt)
//        print(ciphertext)
        
        AuthService.instance.registerUser(username: "james", email: "emailtxt", password: "passwordtxt") { (username, userId) in
            if username != nil, userId != nil {
//                UserdataService.instance.setUserdata1(username: username, avatar: "avatar")
                
                let storyBoard = UIStoryboard.init(name: "CreateRoom", bundle: nil)
                let createRoomVC = storyBoard.instantiateViewController(withIdentifier: "createRoomVC") as! CreateRoomViewController
                self.navigationController?.pushViewController(createRoomVC, animated: true)
            } else {
                print("sign up failed")
            }
        }
    }
    
    //    MARK: IBAction: fbLoginButton
    @IBAction func fbLoginTapped(_ sender: UIButton) {
        fbManagerSuccess{ [unowned self] (success) in
            if success {
                AuthService.instance.registerUser(username: self.loginName!, email: self.loginEmail!, password: "facebookpassword ", completion: { (username, userId) in
//                    print(username, userId)
                    let storyBoard = UIStoryboard.init(name: "CreateRoom", bundle: nil)
                    let createRoomVC = storyBoard.instantiateViewController(withIdentifier: "createRoomVC") as! CreateRoomViewController
                    self.navigationController?.pushViewController(createRoomVC, animated: true)
                })
            }
        }
    }
    
}


