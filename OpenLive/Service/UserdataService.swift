//
//  UserdataService.swift
//  OpenLive
//
//  Created by Sky Xu on 2/12/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation

class UserdataService {
    static let instance = UserdataService()
    
//    other file can access the property in this class, only if it's set
    public private(set) var username = ""
    public private(set) var avatar = ""
    public private(set) var followers = [String]()
    public private(set) var followees = [String]()
    
    func setUserdata1(username: String?, avatar: String?) {
        self.username = username!
        self.avatar = avatar!
    }
    
    func setUserdata2(followees: [String]?, followers: [String]?) {
        self.followees = followees!
        self.followers = followers!
    }
    
//    and then callit in logout funciton and call notification center post
    func logOutUser() {
        avatar = ""
        username = ""
        AuthService.instance.isLoggedIn = false
        
    }
    
    
}
