//
//  RealmManage.swift
//  RealmDemo
//
//  Created by darkgm on 2021/4/29.
//

import UIKit
import RealmSwift

class RealmManage: NSObject {
    static let shared = RealmManage()
    
    var realm: Realm {
        return try! Realm()
    }
    
    func addModel<T>(model: T) {
        do {
            try realm.write {
                realm.add(model as! Object)
                print("model添加成功")
            }
        } catch {
            print("model添加失败:\(error.localizedDescription)")
        }
    }
    
    func addModels<T>(models:[T]) {
        do {
            try realm.write {
                realm.add(models as! [Object], update: .all)
                print("models添加成功")
            }
        } catch {
            print("models添加失败:\(error.localizedDescription)")
        }
    }
    
    func deleteModelList<T>(model: T) {
        do {
            try realm.write {
                realm.delete(realm.objects(T.self as! Object.Type).self)
                print("model删除成功")
            }
        } catch  {
            print("model删除失败:\(error.localizedDescription)")
        }
    }
    
    func updateModel<T>(model: T) {
        do {
            try realm.write {
                realm.add(model as! Object, update: .all)
                print("model更新成功")
            }
        } catch {
            print("model更新失败:\(error.localizedDescription)")
        }
    }
    
    func updateModels<T>(models: [T]) {
        do {
            try realm.write {
                realm.add(models as! [Object], update: .all)
                print("models更新成功")
            }
        } catch {
            print("models更新失败:\(error.localizedDescription)")
        }
    }
    
    func queryModel<T>(model: T, filter: String? = nil) -> [T] {
        var results: Results<Object>
        if filter != nil {
            results = realm.objects((T.self as! Object.Type).self).filter(filter!)
        } else {
            results = realm.objects((T.self as! Object.Type).self)
        }
        guard results.count > 0 else { return [] }
        var models = [T]()
        for result in results {
            models.append(result as! T)
        }
        return models
    }
    
//    func createRealmObject<T: Object>(with json: Any) -> T {
//        do {
//            try realm.write {
//                return realm.create(T.self, value: json, update: .modified)
//            }
//        } catch {
//            print("create realm object failed")
//        }
//        return T()
//    }
}
