//
//  SecondViewController.swift
//  CustomNotificationCenterDemo
//
//  Created by darkgm on 2021/6/16.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SecondVC"
    }
    
    
    @IBAction func PostNotification(_ sender: Any) {
        // 测试下面的情况
        CustomNotificationCenter.default.post(name: changeColorNotification)
//        CustomNotificationCenter.default.post(name: changeColorNotification, object: self)
//        CustomNotificationCenter.default.post(name: changeColorNotification, object: FirstViewController.self)
//        CustomNotificationCenter.default.post(name: changeColorWithParamNotification, object: FirstViewController.self, userInfo: ["color": UIColor.yellow])
    }
    
}
