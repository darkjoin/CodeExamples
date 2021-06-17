//
//  CustomNotification.swift
//  CustomNotificationCenterDemo
//
//  Created by darkgm on 2021/6/16.
//

import UIKit

class CustomNotification: NSObject {
    var observer: AnyObject
    var selector: Selector
    var name: String
    var object: AnyObject?
    var userInfo: [String: Any]?
    
    init(observer: AnyObject, selector: Selector, name: String, object: AnyObject? = nil, userInfo: [String: Any]? = nil) {
        self.observer = observer
        self.selector = selector
        self.name = name
        self.object = object
        self.userInfo = userInfo
    }
}
