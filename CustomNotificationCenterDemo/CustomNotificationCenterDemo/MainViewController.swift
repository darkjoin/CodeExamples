//
//  MainViewController.swift
//  CustomNotificationCenterDemo
//
//  Created by darkgm on 2021/6/16.
//

import UIKit

let changeColorNotification = "changeColorNotification"
let changeColorWithParamNotification = "changeColorWithParamNotification"

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CustomNotificationCenterDemo"
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    private func addObservers() {
//        CustomNotificationCenter.default.addObserver(self, selector: #selector(changeColor), name: changeColorNotification)
//        CustomNotificationCenter.default.addObserver(self, selector: #selector(changeColorWithParam(_:)), name: changeColorWithParamNotification)
        // 解决内存泄漏问题(注意：observer或object用到self时注意内存泄漏问题)
        CustomNotificationCenter.default.addObserver(Proxy(with: self), selector: #selector(changeColor), name: changeColorNotification)
        CustomNotificationCenter.default.addObserver(Proxy(with: self), selector: #selector(changeColorWithParam(_:)), name: changeColorWithParamNotification)
    }
    
    private func removeObservers() {
        CustomNotificationCenter.default.removeObserver(name: changeColorNotification)
        CustomNotificationCenter.default.removeObserver(name: changeColorWithParamNotification)
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
