//
//  CustomNotificationCenter.swift
//  CustomNotificationCenterDemo
//
//  Created by darkgm on 2021/6/16.
//

import UIKit

class CustomNotificationCenter: NSObject {
    var notificationDict = [String: [CustomNotification]]()
    static let `default`: CustomNotificationCenter = CustomNotificationCenter()
    
    func addObserver(_ observer: AnyObject, selector aSelector: Selector, name aName: String, object anObject: AnyObject? = nil) {
        let notification = CustomNotification(observer: observer, selector: aSelector, name: aName, object: anObject)
        guard var notificationArray = notificationDict[aName], !notificationArray.isEmpty else {
            var array = [CustomNotification]()
            array.append(notification)
            notificationDict[aName] = array
            return
        }
        notificationArray.append(notification)
        notificationDict[aName] = notificationArray
    }
    
    func removeObserver(_ observer: AnyObject, name aName: String, object anObject: AnyObject? = nil) {
        guard var notificationArray = notificationDict[aName], !notificationArray.isEmpty else { return }
        if anObject == nil {
            notificationArray.removeAll(where: { $0.name == aName })
        } else {
            notificationArray.removeAll(where: { $0.name == aName && $0.object === anObject })
        }
        notificationDict[aName] = notificationArray
    }
    
    func removeObserver(name aName: String) {
        guard !aName.isEmpty else { return }
        notificationDict.removeValue(forKey: aName)
    }
    
    func post(_ notification: CustomNotification) {
        _ = notification.observer.perform(notification.selector)
    }
    
    func post(name aName: String, object anObject: AnyObject? = nil, userInfo aUserInfo: [String: Any]? = nil) {
        guard let notificationArray = notificationDict[aName], !notificationArray.isEmpty else { return }
        for notification in notificationArray {
            if notification.object != nil { // 添加通知时指定了对象，响应者只会接收该对象发出的通知
                if anObject === notification.object {
                    if let info = aUserInfo, !info.isEmpty {
                        notification.userInfo = info
                        _ = notification.observer.perform(notification.selector, with: notification)
                    } else {
                        _ = notification.observer.perform(notification.selector)
                    }
                }
            } else { // 添加通知时未指定了对象，发送通知时指定对象，响应者也可以接收到
                if let info = aUserInfo, !info.isEmpty {
                    notification.userInfo = info
                    _ = notification.observer.perform(notification.selector, with: notification)
                } else {
                    _ = notification.observer.perform(notification.selector)
                }
            }
            /*
            // --------也可以改成下面这种写法-------------
            guard let object = notification.object else {
                // 添加通知时未指定了对象，发送通知时指定对象，响应者也可以接收到
                if let info = aUserInfo, !info.isEmpty {
                    notification.userInfo = info
                    _ = notification.observer.perform(notification.selector, with: notification)
                } else {
                    _ = notification.observer.perform(notification.selector)
                }
                continue
            }

            // 添加通知时指定了对象，响应者只会接收该对象发出的通知
            guard anObject === object else { continue }
            if let info = aUserInfo, !info.isEmpty {
                notification.userInfo = info
                _ = notification.observer.perform(notification.selector, with: notification)
            } else {
                _ = notification.observer.perform(notification.selector)
            }
             */
        }
    }
    
}


