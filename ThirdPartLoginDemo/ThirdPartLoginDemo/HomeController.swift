//
//  HomeController.swift
//  ThirdPartLoginDemo
//
//  Created by darkgm on 2021/4/16.
//

import UIKit

class HomeController: UIViewController {
    
    deinit {
        print("deinit \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HomePage"
        
        setupSubview()
        layoutSubview()
    }
    
    private func setupSubview() {
        view.addSubview(signOutButton)
    }
    
    private func layoutSubview() {
        signOutButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignOut", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setClickClosure { (button) in
            LaunchService.shared.showLogin()
        }
        return button
    }()
}

