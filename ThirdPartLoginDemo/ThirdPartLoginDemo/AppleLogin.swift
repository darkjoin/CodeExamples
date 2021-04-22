//
//  AppleLogin.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/1.
//

import Foundation
import AuthenticationServices

typealias AppleLoginSuccessClosure = (_ userIdentifier: String) -> Void
typealias AppleLoginFailureClosure = (_ errorMessage: String) -> Void

class AppleLogin: NSObject {
    
    static let shared = AppleLogin()
    private var successClosure: AppleLoginSuccessClosure?
    private var failureClosure: AppleLoginFailureClosure?
    
    override init() {
        super.init()
    }
    
    @available(iOS 13.0, *)
    public func perfromLogin(success: AppleLoginSuccessClosure? = nil, failure: AppleLoginFailureClosure? = nil) {
        self.successClosure = success
        self.failureClosure = failure
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13.0, *)
    public func checkAppleLoginValid(completionHandler: @escaping (Bool) -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                completionHandler(true)
            case .revoked, .notFound:
                completionHandler(false)
            default:
                break
            }
        }
    }
}

@available(iOS 13.0, *)
extension AppleLogin: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // Create an account in your system
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("userIdentifier: \(userIdentifier), fullName: \(String(describing: fullName)), email: \(String(describing: email))")
            self.successClosure?(userIdentifier)
            
            let identityToken = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
            let authorizationCode = String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8)
            print("identityToken: \(String(describing: identityToken)), authorizationCode: \(String(describing: authorizationCode))")
            
            // Store the userIdentifier in the keychain
            self.saveUserInKeychain(userIdentifier)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        var errorMessage = "Signin with apple error: \(error.localizedDescription)"
        print(errorMessage)
        guard let error = error as? ASAuthorizationError else { return }
        switch error.code {
        case .canceled:
            errorMessage = "授权请求取消"
        case .failed:
            errorMessage = "授权请求失败"
        case .invalidResponse:
            errorMessage = "授权请求响应无效"
        case .notHandled:
            errorMessage = "授权请求未能处理"
        default:
            errorMessage = "授权请求未知错误"
        }
        self.failureClosure?(errorMessage)
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "ThirdPartLoginDemo", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
}

@available(iOS 13.0, *)
extension AppleLogin: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return LaunchService.shared.window
    }
}



struct KeychainItem {
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    
    let service: String
    private(set) var account: String
    let accessGroup: String?
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    func readItem() throws -> String {
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        /*
         kSecMatchLimit 指定一个字典键，其值为CFNumberRef。 如果提供，则此值指定最大数量结果返回。 如果未提供，则结果仅限于第一个找到项目。为单个项目提供了预定义的值（kSecMatchLimitOne）和所有匹配项（kSecMatchLimitAll）。
         */
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        //kSecReturnAttributes 是否返回数据Item的非加密属性
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        //对于密钥和密码项目，数据是加密的并可能要求用户输入密码才能访问。
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        // 调用Objective-C APIs，通过指针临时使用&queryResult，只能在Body里使用（$0 = &queryResult）
        let status = withUnsafeMutablePointer(to: &queryResult) {
            /*
             query 包含项目类规范和用于控制搜索的可选属性。
             UnsafeMutablePointer($0) 结果返回时，对找到的项目的CFTypeRef引用。结果的确切类型取决于提供的搜索属性
             result 返回结果code Security Error Codes
             */
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject], let passwordData = existingItem[kSecValueData as String] as? Data, let password = String(data: passwordData, encoding: String.Encoding.utf8) else { throw KeychainError.unexpectedPasswordData }
        return password
    }
    
    func saveItem(_ password: String) throws {
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            try _ = readItem()
            // 找到了就更新
            var attributedToUpdate = [String: AnyObject]()
            attributedToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributedToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            // 没有找到就添加
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func deleteItem() throws {
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError
        }
    }
    
    /// Format查询密钥索引
    /// - Parameters:
    ///   - service: 服务
    ///   - account: 帐号
    ///   - accessGroup: 访问组
    /// - Returns: 组合的索引
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        //kSecClass密钥，其值是Class中的常数常量部分，指定要搜索的项目的类别
        query[kSecClass as String] = kSecClassGenericPassword
        /*
         kSecAttrService指定一个字典键，其值为项目的服务属性。 您可以使用此键设置或获取CFStringRef代表与此项目关联的服务。 （类项目kSecClassGenericPassword具有此属性。)
         */
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            //kSecAttrAccount指定一个字典键，其值为项目的帐户属性。 您可以使用此键设置或获取CFStringRef其中包含一个帐户名。 （类项目kSecClassGenericPassword，kSecClassInternetPassword拥有此功能属性。）
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            /*
             kSecAttrAccessGroup指定一个字典键，其值为一个CFStringRef，指示项目位于哪个访问组中。特定应用程序所属的组由该应用程序有两个权利。应用程序标识符权利包含应用程序的单个访问组，除非存在一个keychain-access-groups权利。后者具有访问组列表作为其值；此列表中的第一项是默认访问组。除非提供了特定的访问组作为调用SecItemAdd时kSecAttrAccessGroup的值，新项在应用程序的默认访问组中创建。指定此SecItemCopyMatching，SecItemUpdate或SecItemDelete调用中的属性将搜索限制为指定的访问组（其中的呼叫应用程序必须是成员才能获得匹配的结果。）多个应用程序之间的钥匙串项，每个应用程序必须具有在其keychain-access-groups权利中列出的公共组，每个组必须将此共享访问组名称指定为字典中的kSecAttrAccessGroup键传递给SecItem函数。
             */
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    static var currentUserIdentifier: String {
        do {
            let storedIdentifier = try KeychainItem(service: "ThirdPartLoginDemo", account: "userIdentifier").readItem()
            return storedIdentifier
        } catch {
            return ""
        }
    }
    
    static func deleteUserIdentifierFromKeychain() {
        do {
            try KeychainItem(service: "ThirdPartLoginDemo", account: "userIdentifier").deleteItem()
        } catch {
            print("Unable to delete userIdentifier from keychain")
        }
    }
}
