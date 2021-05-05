//
//  MessageModel.swift
//  RealmDemo
//
//  Created by darkgm on 2021/4/29.
//

import Foundation
import RealmSwift

class MessageModel: BaseModel {
    
    var ID: String?
    var title: String?
    var pushTimeinterval: TimeInterval = 0
    var pushTime: String?
    var pushDate: Date?
    var isRead = false

    required init?(userInfo: [String : Any]?) {
        super.init(userInfo: userInfo)

        if let modelInfo = self.userInfo, modelInfo.count > 0 {

            self.ID = modelInfo["msg_id"] as? String
            self.title = modelInfo["title"] as? String
            self.isRead = modelInfo["read_state"] as? Bool ?? false
            self.pushTimeinterval = TimeInterval(modelInfo["push_time"] as? String ?? "") ?? 0
            if self.pushTimeinterval > 0 {
                self.pushTime = string(from: pushTimeinterval, with: "yyyy-MM-dd HH:mm")
                self.pushDate = Date(timeIntervalSince1970: self.pushTimeinterval)
            }
        }
    }
    
    func string(from timestamp: TimeInterval, with format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date.init(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

class BaseModel {
    var userInfo:[String:Any]? = [:]
    required init?(userInfo:[String:Any]?) {
        
        self.userInfo = userInfo
        if let infos = self.userInfo {
            if infos.count <= 0 {
                return nil
            }
        }else {
            return nil
        }
    }
}

class RealmMessageModel: Object {
    @objc dynamic var ID: String?
    @objc dynamic var title: String?
    @objc dynamic var pushTimeinterval: TimeInterval = 0
    @objc dynamic var pushTime: String?
    @objc dynamic var pushDate: Date?
    @objc dynamic var isRead = false
}
