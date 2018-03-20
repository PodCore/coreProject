//
//  LoginViewController.swift
//  OpenLive
//
//  Created by Andrew Tsukuda on 3/15/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Google

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var loginName: String?
    var loginEmail: String?
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var gmailButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpGoogleSignIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
    }
    
    //   MARK: (helper) main func to call google Signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        AuthService.instance.registerUser(username: user.profile.givenName, email: user.profile.email, password: "gmailpassword ", completion: {[unowned self] (username, userId) in
            //print(username, userId)
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let tabBarVC = storyBoard.instantiateViewController(withIdentifier: "tabBarVC")
            UserdataService.instance.setUserdata1(username: username, avatar: "avatar")
            self.navigationController?.pushViewController(tabBarVC, animated: true)
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
    
    //    MARK: IBAction: fbLoginButton
    @IBAction func fbLoginTapped(_ sender: UIButton) {
        fbManagerSuccess{ [unowned self] (success) in
            if success {
                AuthService.instance.registerUser(username: self.loginName!, email: self.loginEmail!, password: "facebookpassword ", completion: { (username, userId) in
                    //                    print(username, userId)
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let createRoomVC = storyBoard.instantiateViewController(withIdentifier: "tabBarVC")
                    self.navigationController?.pushViewController(createRoomVC, animated: true)
                })
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
