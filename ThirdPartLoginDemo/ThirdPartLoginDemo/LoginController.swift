//
//  LoginController.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/16.
//

import UIKit
import SnapKit
import JGProgressHUD

class LoginController: UIViewController {
    
    deinit {
        print("deinit \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ThirdPartLoginDemo"
        view.backgroundColor = .white
        
        setupSubview()
        layoutSubview()
    }
    
    private func setupSubview() {
        view.addSubview(customLoginItemsView)
    }
    
    private func layoutSubview() {
        customLoginItemsView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        }
    }
    
    lazy var customLoginItemsView: CustomLoginItemsView = {
        let view = CustomLoginItemsView()
        view.loginItemClicked = { [weak self] (type) in
            switch type {
            case .Facebook:
                self?.loginWithFacebook()
            case .Line:
                self?.loginWithLine()
            case .Apple:
                self?.loginWithApple()
            }
        }
        return view
    }()
    
}

extension LoginController {
    private func loginWithFacebook() {
        FacebookLogin.shared.performLogin { (userID, accessToken) in
            debugPrint("Facebook登录授权成功：userID \(userID), accessToken \(accessToken)")
            // 授权成功执行后续操作
            LaunchService.shared.showHome()
        } failure: { [weak self] (errorMessage) in
            self?.showHUD(with: "Facebook登录授权失败：\(errorMessage)")
        }
    }
    
    private func loginWithLine() {
        LineLogin.shared.performLogin { (userID, accessToken) in
            debugPrint("Line登录授权成功：userID \(userID), accessToken \(accessToken)")
            // 授权成功执行后续操作
            LaunchService.shared.showHome()
        } failure: { [weak self] (errorMessage) in
            self?.showHUD(with: "Line登录授权失败：\(errorMessage)")
        }
    }
    
    private func loginWithApple() {
        if #available(iOS 13.0, *) {
            AppleLogin.shared.perfromLogin { (userID) in
                debugPrint("AppleID登录授权成功：\(userID)")
                // 授权成功执行后续操作
                LaunchService.shared.showHome()
            } failure: { [weak self] (errorMessage) in
                self?.showHUD(with: "AppleID登录授权失败：\(errorMessage)")
            }
        } else {
            self.showHUD(with: "使用AppleID登录仅支持iOS 13.0及以上的系统")
        }
    }
}

extension LoginController {
    private func showHUD(with message: String) {
        let hud = JGProgressHUD()
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: view)
        hud.dismiss(afterDelay: 2.0)
    }
}


