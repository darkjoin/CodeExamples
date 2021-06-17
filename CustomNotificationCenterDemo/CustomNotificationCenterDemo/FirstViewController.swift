//
//  FirstViewController.swift
//  CustomNotificationCenterDemo
//
//  Created by darkgm on 2021/6/16.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "FirstVC"
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    private func addObservers() {
//        CustomNotificationCenter.default.addObserver(self, selector: #selector(changeColor), name: changeColorNotification, object: FirstViewController.self)
//        CustomNotificationCenter.default.addObserver(self, selector: #selector(changeColorWithParam(_:)), name: changeColorWithParamNotification, object: FirstViewController.self)
        // 解决内存泄漏问题(注意：observer或object用到self时注意内存泄漏问题)
//        CustomNotificationCenter.default.addObserver(Proxy(with: self), selector: #selector(changeColor), name: changeColorNotification, object: Proxy(with: self))
        CustomNotificationCenter.default.addObserver(Proxy(with: self), selector: #selector(changeColor), name: changeColorNotification, object: FirstViewController.self)
        CustomNotificationCenter.default.addObserver(Proxy(with: self), selector: #selector(changeColorWithParam(_:)), name: changeColorWithParamNotification, object: FirstViewController.self)
    }
    
    private func removeObservers() {
        CustomNotificationCenter.default.removeObserver(self, name: changeColorNotification, object: FirstViewController.self)
        CustomNotificationCenter.default.removeObserver(self, name: changeColorWithParamNotification, object: FirstViewController.self)
    }
    
    @objc private func changeColor() {
        view.backgroundColor = .orange
    }
    
    @objc private func changeColorWithParam(_ notification: CustomNotification) {
        guard let userInfo = notification.userInfo, !userInfo.isEmpty else { return }
        let color = userInfo["color"] as? UIColor
        view.backgroundColor = color
    }

}
