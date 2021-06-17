//
//  Proxy.swift
//  CustomNotificationCenterDemo
//
//  Created by darkgm on 2021/6/16.
//

import UIKit

class Proxy: NSObject {
    weak var target: AnyObject?
    
    init(with target: AnyObject?) {
        self.target = target
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return self.target
    }
}
