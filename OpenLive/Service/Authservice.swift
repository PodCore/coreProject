//
//  Authservice.swift
//  Streaming
//
//  Created by Sky Xu on 1/23/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandler = (_ username: String?, _ userId: String?) -> ()

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: "isRegistered")
        }
        set {
            defaults.set(newValue, forKey: "isRegistered")
        }
    }
    var username: String {
        get {
            return defaults.string(forKey: "username")!
        }
        set {
            defaults.set(newValue, forKey: "username")
        }
    }
    
//    var keychainLoggedIn: Bool {
//        get {
//
//        }
//
//        set {
//
//        }
//    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: "TOKEN_KEY") as! String
        }
        set {
//            keychain.set
            defaults.set(newValue, forKey: "TOKEN_KEY")
        }
    }
   
    func registerUser(username: String, email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let body: [String: Any] = [
            "username": username,
            "email": lowerCaseEmail,
            "password": password
        ]
        let BASE_URL = Config.serverUrl + "/register"
        let HEADER = [
            "Content-Type": "application/json"
        ]
       
   
        Alamofire.request(BASE_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON{ (response) in
            if response.result.error == nil {
                guard let json = response.result.value as? [String: Any] else { return }
                print(json)
                guard let name = json["username"],
                    let userId = json["_id"] else { return }
                //   update userdata so we can use notification center to notify profile page update
//                self.setUserInfo(json: json)
                // MARK: update userdefault of isloggIn
                self.isLoggedIn = true
                self.username = name as! String
                completion(name as? String, userId as? String)
            } else {
                completion(nil, nil)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
//    find user by username caz username is unique
    func getUserByUsername(completion: @escaping (Bool) -> Void) {
        
        let BASE_URL = Config.serverUrl + "/username"
        
        Alamofire.request(BASE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response) in
            if response.result.error == nil {
                guard let data = response.result.value as? [String: Any] else { return }
//                self.setUserFollowInfo(json: data)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func setUserInfo(json:[String: Any]) {
        let username = json["username"] as! String
        let avatar = json["avatar"] as! String
//        only pass in value of username and avatar now since we have no followee and followers when first registered
        UserdataService.instance.setUserdata1(username: username, avatar: avatar)
    }
    
    func setUserFollowInfo(json:[String: Any]){
        let followees = json["followees"] as! [String]
        let followers = json["followers"] as! [String]
     UserdataService.instance.setUserdata2(followees: followees, followers: followers)
    }

}


