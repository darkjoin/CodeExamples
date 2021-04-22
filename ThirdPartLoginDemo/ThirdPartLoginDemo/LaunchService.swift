//
//  LaunchService.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/16.
//

import UIKit

class LaunchService {
    
    static let shared = LaunchService()
    
    init() {
        window.makeKeyAndVisible()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window = window
    }
    
    lazy var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        return window
    }()
    
    public func start() {
        showLogin()
    }
    
    public func showLogin() {
        let loginController = LoginController()
        let nav = UINavigationController(rootViewController: loginController)
        window.rootViewController = nav
    }
    
    public func showHome() {
        let homeController = HomeController()
        let nav = UINavigationController(rootViewController: homeController)
        window.rootViewController = nav
    }
}
