//
//  RegisterViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/23/18.
//  Copyright © 2018 Sky Xu. All rights reserved.


import UIKit
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Google
import IHKeyboardAvoiding

class RegisterViewController: PassAlertViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeyboardAvoiding.avoidingView = self.passwordTextField
        KeyboardAvoiding.avoidingView = self.signUpBtn
    }
    
    func dismissKeyboard() {
        passwordTextField.resignFirstResponder()
    }
    
    //    MARK: IBAction: RegularSignupButton
    @IBAction func signupClicked(_ sender: UIButton) {
        self.dismissKeyboard()
        guard let usernametxt = usernameTextField.text, let emailtxt = emailTextField.text, let passwordtxt = passwordTextField.text,
                !usernametxt.isEmpty, !emailtxt.isEmpty, !passwordtxt.isEmpty else { return }
        
        AuthService.instance.registerUser(username: usernametxt, email: emailtxt, password: passwordtxt) { (username, userId, error)  in  //username and userID from authservice
            if username != nil, userId != nil {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let mainVC = storyBoard.instantiateViewController(withIdentifier: "mainTabBarController")
                self.present(mainVC, animated: true)
            } else {
                self.showAlertView(title: "Error Creating Account", message: "Your account could not be created: \(error!)")
            }
        }
    }
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
