//
//  AppDelegate.swift
//  OpenLive
//
//  Created by GongYuhua on 6/25/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import GoogleSignIn
import SocketIO
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var hostLocation: Location?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBHgkQDzeLMYwL3l0p2OEf7nX57FRsUUHw")
        /* Facebook login */
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        LocationService.shared.convertToRegion { (location, success) in
            if success {
                self.hostLocation = location
            }
        }
        return true
    }
    
    //    MARK: for FBSDK
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication.rawValue] as? String,
                                                 annotation: [UIApplicationOpenURLOptionsKey.annotation.rawValue])
    }
    
    // MARK:   connect to socket when first launch app
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        SocketService.instance.establishConnection()
        return true
    }
    
    // MARK: get new rooms everytime we renter the app
    func applicationWillEnterForeground(_ application: UIApplication) {
         SocketService.instance.observeIfConnected { (payload, ack) in
            SocketService.instance.getNewChannel { (success, newRoom) in
                if success {
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let homeVC = storyBoard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
                    homeVC.newPopularVideos.append(newRoom)
                    LiveRoomData.instance.appendRoom(liveRoom: newRoom)
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }
    
    //    MARK: leave Socket
    func applicationWillTerminate(_ application: UIApplication) {
        SocketService.instance.closeConnection()
    }
}
