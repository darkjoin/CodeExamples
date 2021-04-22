//
//  LineLogin.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/7.
//
// 参考文档：https://developers.line.biz/en/docs/ios-sdk/swift/overview/#what-s-in-this-guide

import Foundation
import LineSDK

typealias LineLoginSuccessClosure = (_ userID: String, _ accessToken: String) -> Void
typealias LineLoginFailureClosure = (_ errorMessage: String) -> Void

class LineLogin: NSObject {
    
    static let shared = LineLogin()
    private var successClosure: LineLoginSuccessClosure?
    private var failureClosure: LineLoginFailureClosure?
    
    override init() {
        super.init()
    }
    
    public func performLogin(success: LineLoginSuccessClosure? = nil, failure: LineLoginFailureClosure? = nil) {
        self.successClosure = success
        self.failureClosure = failure
        
        LoginManager.shared.login(permissions: [.profile], in: LaunchService.shared.window.rootViewController) { (result) in
            switch result {
            case .success(let loginResult):
                print("Login successed, accessToken: \(loginResult.accessToken.value), userID: \(String(describing: loginResult.userProfile?.userID))")
                self.successClosure?(loginResult.userProfile?.userID ?? "", loginResult.accessToken.value)
            case .failure(let error):
                self.failureClosure?(error.localizedDescription)
            }
        }
    }
    
    public func checkLineLoginValid(completionHandler: @escaping (Bool) -> Void) {
        guard let token = AccessTokenStore.shared.current, !token.value.isEmpty else {
            completionHandler(false)
            return
        }
        completionHandler(true)
    }
}
