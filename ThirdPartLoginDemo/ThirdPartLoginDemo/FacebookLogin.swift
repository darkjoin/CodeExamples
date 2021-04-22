//
//  FacebookLogin.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/2.
//
// 参考文档：https://developers.facebook.com/docs/facebook-login/ios/v2.2?locale=zh_CN

import Foundation
import FBSDKLoginKit

typealias FacebookLoginSucessClosure = (_ userID: String, _ accessToken: String) -> Void
typealias FacebookLoginFailureClosure = (_ errorMessage: String) -> Void

class FacebookLogin: NSObject {
    
    static let shared = FacebookLogin()
    private var successClosure: FacebookLoginSucessClosure?
    private var failureClosure: FacebookLoginFailureClosure?
    
    override init() {
        super.init()
    }
    
    public func performLogin(success: FacebookLoginSucessClosure? = nil, failure: FacebookLoginFailureClosure? = nil) {
        self.successClosure = success
        self.failureClosure = failure
        
        LoginManager().logIn(permissions: [.publicProfile], viewController: LaunchService.shared.window.rootViewController) { (loginResult) in
            switch loginResult {
            case .success(granted: let grantedPermissions, declined: let declinedPermissions, token: let accessToken):
                print("Login successed, \(grantedPermissions), \(declinedPermissions), \(String(describing: accessToken))")
                guard let accessToken = accessToken, !accessToken.isExpired else { return }
                self.successClosure?(accessToken.userID, accessToken.tokenString)
            case .failed(let error):
                print(error)
                self.failureClosure?(error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
                self.failureClosure?("用户取消登录")
            }
        }
    }
    
    public func checkFacebookLoginValid(completionHandler: @escaping (Bool) -> Void) {
        guard let token = AccessToken.current, !token.isExpired else {
            completionHandler(false)
            return
        }
        completionHandler(true)
    }
}
