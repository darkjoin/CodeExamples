//
//  AppDelegate.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/16.
//

import UIKit
import FBSDKCoreKit
import LineSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LaunchService.shared.start()
        
        // Initialize the FacebookSDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //  Setup LineSDK
        LoginManager.shared.setup(channelID: "1655881766", universalLinkURL: nil)
        
        return true
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Facebook:
        //return ApplicationDelegate.shared.application(app, open: url, options: options)
        
        // Line:
//        return LoginManager.shared.application(app, open: url, options: options)
        
        return ApplicationDelegate.shared.application(app, open: url, options: options) || LoginManager.shared.application(app, open: url, options: options)
    }
}

